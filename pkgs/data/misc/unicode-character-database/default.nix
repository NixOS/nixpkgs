{ lib, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "unicode-character-database";
  version = "14.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/zipped/${version}/UCD.zip";
    sha256 = "sha256-AzpSdrXXr4hEWJ+ONILzl3qDhecdEH03UFVGUXjCNgA=";
  };

  nativeBuildInputs = [
    unzip
  ];

  setSourceRoot = ''
    sourceRoot=$PWD
  '';

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
