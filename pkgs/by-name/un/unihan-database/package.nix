{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "unihan-database";
  version = "15.1.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/zipped/${version}/Unihan.zip";
    hash = "sha256-oCJmEOMkvPeErDgOEfTL9TPuHms9AosJkb+MDcP4WFM=";
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
