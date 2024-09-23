{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation rec {
  pname = "tidgi";
  version = "0.9.6";

  src =
    if stdenv.isAarch64
    then
      fetchurl
      {
        url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/v${version}/TidGi-darwin-arm64-${version}.zip";
        hash = "sha256-1Z9lxZZWrUVQEhBO/Kt2AS/uNs2XfihdL0iGrguPQ5g=";
      }
    else
      fetchurl
      {
        url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/v${version}/TidGi-darwin-x64-${version}.zip";
        hash = "sha256-5jHW/QrgzsGQfX4LvsRebdOJPzYTvhtC5mczxp2wPI8=";
      };

  dontBuild = true;

  nativeBuildInputs = [unzip];

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
    maintainers = with lib.maintainers; [klchen0112];
    platforms = ["aarch64-darwin" "x86_64-darwin"];
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
  };
}
