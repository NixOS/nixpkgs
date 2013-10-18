{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "liberation-fonts-1.04";
  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/liberation-fonts/${name}.tar.gz";
    sha256 = "189i6pc4jqhhmsb9shi8afg9af9crpmz9bnlldhqaxavr1bhj38f";
  };
  
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype

    mkdir -p "$out/doc/${name}"
    cp -v AUTHORS ChangeLog COPYING License.txt README "$out/doc/${name}"
  '';

  meta = {
    description = "Liberation Fonts, replacements for Times New Roman, Arial, and Courier New";

    longDescription = ''
      The Liberation Fonts are intended to be replacements for the three most
      commonly used fonts on Microsoft systems: Times New Roman, Arial, and
      Courier New.

      There are three sets: Sans (a substitute for Arial, Albany, Helvetica,
      Nimbus Sans L, and Bitstream Vera Sans), Serif (a substitute for Times
      New Roman, Thorndale, Nimbus Roman, and Bitstream Vera Serif) and Mono
      (a substitute for Courier New, Cumberland, Courier, Nimbus Mono L, and
      Bitstream Vera Sans Mono).

      You are free to use these fonts on any system you would like.  You are
      free to redistribute them under the GPL+exception license found in the
      download.  Using these fonts does not subject your documents to the
      GPL---it liberates them from any proprietary claim.
    '';

    # See `License.txt' for details.
    license = "GPLv2 + exception";

    homepage = https://fedorahosted.org/liberation-fonts/;

    maintainers = [
      stdenv.lib.maintainers.raskin
      stdenv.lib.maintainers.ludo
    ];
  };
}
