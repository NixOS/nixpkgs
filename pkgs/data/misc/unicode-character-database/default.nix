{ stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "unicode-character-database";
  version = "13.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/zipped/${version}/UCD.zip";
    sha256 = "0ld97ppkb5f8d5b3mlkxfwnr6f3inijyqias9xc4bbin9lxrfxig";
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

  meta = with stdenv.lib; {
    description = "Unicode Character Database";
    homepage = "https://www.unicode.org/";
    license = licenses.free; # https://www.unicode.org/license.html
    platforms = platforms.all;
  };
}
