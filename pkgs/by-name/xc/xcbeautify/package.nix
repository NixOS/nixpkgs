{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "xcbeautify";
  version = "2.4.1";

  src = fetchurl {
    url = "https://github.com/cpisciotta/xcbeautify/releases/download/${version}/xcbeautify-${version}-${stdenv.hostPlatform.darwinArch}-apple-macosx.zip";
    hash = lib.getAttr stdenv.hostPlatform.darwinArch {
      arm64 = "sha256-EjBhpw9qsOEweXOepQVPNL/hCxj12Z5gyvv7neNEeMU=";
      x86_64 = "sha256-Zb54g0cMWB6ouzLPUd+VTCicp+bVb5aDKxNSB3eGaZU=";
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
