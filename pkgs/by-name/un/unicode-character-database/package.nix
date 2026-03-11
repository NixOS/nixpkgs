{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "unicode-character-database";
  version = "18.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/${version}/ucd/UCD.zip";
    sha256 = "sha256-yWHUQF7dFEtQUs+vi/fbVK9E68XbcYH4PGxS35npNjo=";
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

  meta = {
    description = "Unicode Character Database";
    homepage = "https://www.unicode.org/";
    license = lib.licenses.unicode-dfs-2016;
    platforms = lib.platforms.all;
  };
}
