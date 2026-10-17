{
  lib,
  fetchFromGitHub,
  symlinkJoin,
  buildGo127Module,
  makeWrapper,
  nix-update-script,
  v2ray-rules-dat,
  assets ? [
    v2ray-rules-dat
  ],
}:

buildGo127Module (finalAttrs: {
  pname = "xray";
  version = "26.10.10";

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M6biUT2RgP4xNGj9RUAVG7rrGNm65+sWL7pRQpbpWFI=";
  };

  vendorHash = "sha256-XfTEpPMKyIhaoG53omH5rewI86QFNc9pnzhvZvxgFp0=";

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
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ iopq ];
  };
})
