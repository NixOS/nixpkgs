{ lib, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "unicode-character-database";
  version = "15.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/zipped/${version}/UCD.zip";
    sha256 = "sha256-X73kAPPmh9JcybCo0w12GedssvTD6Fup347BMSy2cYw=";
  };

  nativeBuildInputs = [
    unzip
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode
    cp -r * $out/share/unicode

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode Character Database";
    homepage = "https://www.unicode.org/";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
  };
}
