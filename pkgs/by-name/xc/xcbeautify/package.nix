{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "xcbeautify";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/cpisciotta/xcbeautify/releases/download/${version}/xcbeautify-${version}-${stdenv.hostPlatform.darwinArch}-apple-macosx.zip";
    hash = lib.getAttr stdenv.hostPlatform.darwinArch {
      arm64 = "sha256-4b4mXT5IfNOS8iOrZASDhTrmOehG4mePcoiKxR+IdZk=";
      x86_64 = "sha256-adEfAK7n3Q/Yd1deyJx7htX7hZaGDztEeBv4z2A0wzg=";
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

  meta = with lib; {
    description = "Little beautifier tool for xcodebuild";
    homepage = "https://github.com/cpisciotta/xcbeautify";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "xcbeautify";
    maintainers = with maintainers; [ siddarthkay ];
  };
}
