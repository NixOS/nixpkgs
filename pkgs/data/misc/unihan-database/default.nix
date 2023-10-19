{ lib, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "unihan-database";
  version = "15.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/zipped/${version}/Unihan.zip";
    hash = "sha256-JLFUaR/JfLRCZ7kl1iBkKXCGs/iWtXqBgce21CcCoCY=";
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
    description = "Unicode Han Database";
    homepage = "https://www.unicode.org/";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
  };
}
