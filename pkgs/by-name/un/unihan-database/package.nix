{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unihan-database";
  version = "18.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/${finalAttrs.version}/ucd/Unihan.zip";
    hash = "sha256-TJPqnB9jZFFymoQJePFmelOIavN7qFT9zOEJchxj1D4=";
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

  meta = {
    description = "Unicode Han Database";
    homepage = "https://www.unicode.org/";
    license = lib.licenses.unicode-30;
    platforms = lib.platforms.all;
  };
})
