{stdenv, fetchurl, fontforge, pythonPackages, python}:

stdenv.mkDerivation rec {
  name = "liberation-fonts-2.00.1";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/liberation-fonts/${name}.tar.gz";
    sha256 = "1ymryvd2nw4jmw4w5y1i3ll2dn48rpkqzlsgv7994lk6qc9cdjvs";
  };

  buildInputs = [ fontforge pythonPackages.fonttools python ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v $(find . -name '*.ttf') $out/share/fonts/truetype

    mkdir -p "$out/doc/${name}"
    cp -v AUTHORS ChangeLog COPYING License.txt README "$out/doc/${name}" || true
  '';

  meta = with stdenv.lib; {
    description = "Liberation Fonts, replacements for Times New Roman, Arial, and Courier New";
    longDescription = ''
      The Liberation Fonts are intended to be replacements for the three most
      commonly used fonts on Microsoft systems: Times New Roman, Arial, and
      Courier New. Since 2012 they are based on croscore fonts.

      There are three sets: Sans (a substitute for Arial, Albany, Helvetica,
      Nimbus Sans L, and Bitstream Vera Sans), Serif (a substitute for Times
      New Roman, Thorndale, Nimbus Roman, and Bitstream Vera Serif) and Mono
      (a substitute for Courier New, Cumberland, Courier, Nimbus Mono L, and
      Bitstream Vera Sans Mono).
    '';

    license = licenses.ofl;
    homepage = https://fedorahosted.org/liberation-fonts/;
    maintainers = [
      maintainers.raskin
    ];
    platforms = platforms.unix;
  };
}
