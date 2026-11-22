{
  lib,
  fetchFromGitHub,
  symlinkJoin,
  buildGo127Module,
  makeWrapper,
  nix-update-script,
  xray-rules-dat,
  assets ? [
    xray-rules-dat
  ],
}:

buildGo127Module (finalAttrs: {
  pname = "xray";
  version = "26.11.9";

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1XxY2RnbDY2WrCPpsr/jfx1cFIxcBdx2IDGM3ow9MXc=";
  };

  vendorHash = "sha256-67Z5i14wwGBVTiUKzijNUctbNK93n/dpKFpwJZG8ysw=";

  patches = [
    ./use-system-certs.patch
  ];

  postPatch = ''
    sed -i '/golang\.org\/x\/crypto\/x509roots\/fallback/d' go.mod
    sed -i '/golang\.org\/x\/crypto\/x509roots\/fallback/d' go.sum
  '';

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
    name = "xray-assets";
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
    maintainers = with lib.maintainers; [
      iopq
      nix-julia
    ];
  };
})
