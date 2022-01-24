{ lib, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "unihan-database";
  version = "12.1.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/zipped/${version}/Unihan.zip";
    sha256 = "1kfdhgg2gm52x3s07bijb5cxjy0jxwhd097k5lqhvzpznprm6ibf";
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
    description = "Unicode Han Database";
    homepage = "https://www.unicode.org/";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
  };
}
