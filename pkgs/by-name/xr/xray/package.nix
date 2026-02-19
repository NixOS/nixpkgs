{
  lib,
  fetchFromGitHub,
  symlinkJoin,
  buildGo126Module,
  makeWrapper,
  nix-update-script,
  v2ray-geoip,
  v2ray-domain-list-community,
  assets ? [
    v2ray-geoip
    v2ray-domain-list-community
  ],
}:

buildGo126Module (finalAttrs: {
  pname = "xray";
  version = "26.2.6";

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WTCehvvk/f2/IemzGDq3Y0dM/n0iKAH8CeVyoTimFqQ=";
  };

  vendorHash = "sha256-JOstg2Q7UTFn904MMjqk+BCRd7opfNDj+WI0sCSHbDA=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];
  subPackages = [ "main" ];

  installPhase = ''
    runHook preInstall
    install -Dm555 "$GOPATH"/bin/main $out/bin/xray
    runHook postInstall
  '';

  assetsDrv = symlinkJoin {
    name = "v2ray-assets";
    paths = assets;
  };

  postFixup = ''
    wrapProgram $out/bin/xray \
      --set-default V2RAY_LOCATION_ASSET $assetsDrv/share/v2ray \
      --set-default XRAY_LOCATION_ASSET $assetsDrv/share/v2ray
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Platform for building proxies to bypass network restrictions. A replacement for v2ray-core, with XTLS support and fully compatible configuration";
    mainProgram = "xray";
    homepage = "https://github.com/XTLS/Xray-core";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ iopq ];
  };
})
