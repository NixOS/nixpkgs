{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zulip";
  version = "5.12.4";

  src = fetchurl {
    url = "https://github.com/zulip/zulip-desktop/releases/download/v${version}/Zulip-${version}-arm64.zip";
    hash = "sha256-kSiU+vk3KeNvyOcDWK4GeT09gBPFnm/DRk4WIpZIZlc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R Zulip.app $out/Applications/
    mkdir -p $out/bin
    makeWrapper $out/Applications/Zulip.app/Contents/MacOS/Zulip $out/bin/zulip
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Desktop client for Zulip Chat on macOS";
    homepage = "https://zulip.com";
    changelog = "https://github.com/zulip/zulip-desktop/releases/tag/v${version}";
    mainProgram = "zulip";
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ deadbaed ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
