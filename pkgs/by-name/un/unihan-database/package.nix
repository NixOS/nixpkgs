{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "unihan-database";
  version = "17.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/${version}/ucd/Unihan.zip";
    hash = "sha256-96SLK1Raz6p3stYHrih0dATOArrv7hY5bF0teo7zS14=";
  };

  nativeBuildInputs = [
    unzip
  ];

  sourceRoot = "source";

  unpackPhase = ''
    runHook preUnpack
    unzip $src -d $sourceRoot
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode
    cp -r * $out/share/unicode

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode Han Database";
    homepage = "https://www.unicode.org/";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
  };
}
