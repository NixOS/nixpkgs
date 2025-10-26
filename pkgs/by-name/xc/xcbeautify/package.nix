{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "xcbeautify";
  version = "3.1.1";

  src = fetchurl {
    url = "https://github.com/cpisciotta/xcbeautify/releases/download/${version}/xcbeautify-${version}-${stdenv.hostPlatform.darwinArch}-apple-macosx.zip";
    hash = lib.getAttr stdenv.hostPlatform.darwinArch {
      arm64 = "sha256-YJnQ7VDjQK3w2pweEDpiBF5sZsHc94ZECpeDu0ncxp8=";
      x86_64 = "sha256-LRyA9uODhYFxAc6RtWi6zmkSaPm/dAaSqzmbV0bRWWk=";
    };
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -D xcbeautify $out/bin/xcbeautify

    runHook postInstall
  '';

  meta = {
    description = "Little beautifier tool for xcodebuild";
    homepage = "https://github.com/cpisciotta/xcbeautify";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "xcbeautify";
    maintainers = with lib.maintainers; [ siddarthkay ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
