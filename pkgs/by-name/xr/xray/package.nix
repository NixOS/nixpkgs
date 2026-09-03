{
  lib,
  fetchFromGitHub,
  symlinkJoin,
  buildGo126Module,
  makeWrapper,
  nix-update-script,
  v2ray-rules-dat,
  assets ? [
    v2ray-rules-dat
  ],
}:

buildGo126Module (finalAttrs: {
  pname = "xray";
  version = "26.7.28";

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6qW8Un6VC0kFPyrFMQxruWz18flyeZyFs0A7avoi56I=";
  };

  vendorHash = "sha256-n1/bxtOadcdnXg/opvv7gU2Dr/vbt5kGfdZCyk9CY8w=";

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
