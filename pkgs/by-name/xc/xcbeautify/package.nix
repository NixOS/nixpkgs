{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "xcbeautify";
<<<<<<< HEAD
  version = "3.1.1";
=======
  version = "2.27.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchurl {
    url = "https://github.com/cpisciotta/xcbeautify/releases/download/${version}/xcbeautify-${version}-${stdenv.hostPlatform.darwinArch}-apple-macosx.zip";
    hash = lib.getAttr stdenv.hostPlatform.darwinArch {
<<<<<<< HEAD
      arm64 = "sha256-YJnQ7VDjQK3w2pweEDpiBF5sZsHc94ZECpeDu0ncxp8=";
      x86_64 = "sha256-LRyA9uODhYFxAc6RtWi6zmkSaPm/dAaSqzmbV0bRWWk=";
=======
      arm64 = "sha256-8HEge1LvnEZQbliEDO+FP485V/OddBBESfCXnI/v2dE=";
      x86_64 = "sha256-s1YyXEUJ7I0UhNEPSGregTFHpDKlFQ6ezvUXFk/0J6Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
