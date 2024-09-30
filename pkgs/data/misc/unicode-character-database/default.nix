{ lib, stdenvNoCC
, fetchurl
, unzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "unicode-character-database";
  version = "15.1.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/zipped/${version}/UCD.zip";
    sha256 = "sha256-yxxmPQU5JlAM1QEilzYEV1JxOgZr11gCCYWYt6cFYXc=";
  };

  nativeBuildInputs = [
    unzip
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode
    cp -r * $out/share/unicode
    rm $out/share/unicode/env-vars

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode Character Database";
    homepage = "https://www.unicode.org/";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
  };
}
