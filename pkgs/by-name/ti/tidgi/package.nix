{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation rec {
  pname = "tidgi";
  version = "0.12.1";

  src =
    {
      x86_64-darwin = fetchurl {
        url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/v${version}-update/TidGi-darwin-x64-${version}.zip";
        hash = "sha256-XZraotf6ewsrb2LBbZTTRMrT+B52NNWsZY/Qxju8hNw=";
      };
      aarch64-darwin = fetchurl {
        url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/v${version}-update/TidGi-darwin-arm64-${version}.zip";
        hash = "sha256-/fcMCS7k2LT0ELcrFPpiQ/WNJtxaJoYOLLhROHTgIdY=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontBuild = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/tag/v${version}";
    description = "Customizable personal knowledge-base and blogging platform with git as backup manager";
    homepage = "https://github.com/tiddly-gittly/TidGi-Desktop";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ klchen0112 ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
