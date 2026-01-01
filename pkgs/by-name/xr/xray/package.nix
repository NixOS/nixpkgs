{
  lib,
  fetchFromGitHub,
  symlinkJoin,
  buildGoModule,
  makeWrapper,
  nix-update-script,
  v2ray-geoip,
  v2ray-domain-list-community,
  assets ? [
    v2ray-geoip
    v2ray-domain-list-community
  ],
}:

buildGoModule rec {
  pname = "xray";
<<<<<<< HEAD
  version = "25.12.8";
=======
  version = "25.10.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6A+1Anl0LRsF5bzYjHkqUAyRPbClQwQEElDeEvGfgyc=";
  };

  vendorHash = "sha256-LzCjzEOREqR108v7zR5jWuDwcrb1K58rpv9RyQUxgic=";
=======
    hash = "sha256-E3Ozd2pFLuoV1xc3rPIoh6+ErAN9MYquxwzVTvETMlA=";
  };

  vendorHash = "sha256-Dzml+y6KSCcRqgWk8rP3gGFE1UsGNhNpu2I5NkCBztw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
}
