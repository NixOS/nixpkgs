{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "ipafont-003.03";

  src = fetchurl {
    url = "http://ipafont.ipa.go.jp/old/ipafont/IPAfont00303.php";
    sha256 = "f755ed79a4b8e715bed2f05a189172138aedf93db0f465b4e20c344a02766fe5";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp ./IPAfont00303/*.ttf $out/share/fonts/opentype/
  '';

  meta = {
    description = "Japanese font package with Mincho and Gothic fonts";
    longDescription = ''
      IPAFont is a Japanese font developed by the Information-technology
      Promotion Agency of Japan. It provides both Mincho and Gothic fonts,
      suitable for both display and printing.
    '';
    homepage = http://ipafont.ipa.go.jp/ipafont/;
    license = stdenv.lib.licenses.ipa;
    maintainers = [ stdenv.lib.maintainers.auntie ];
    platforms = stdenv.lib.platforms.unix;
  };
}
