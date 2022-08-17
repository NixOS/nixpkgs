{ lib, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "unihan-database";
  version = "14.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/zipped/${version}/Unihan.zip";
    hash = "sha256-KuRRmyuCzU0VN5wX5Xv7EsM8D1TaSXfeA7KwS88RhS0=";
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
