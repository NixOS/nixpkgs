{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "unicode-character-database";
  version = "17.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/${version}/ucd/UCD.zip";
    sha256 = "sha256-IGbRkJsuqTkWzgktocDuSAjqPvhAfJS08U9bfrJj0o4=";
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
