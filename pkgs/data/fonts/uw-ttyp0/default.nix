{ stdenv, perl, fetchurl, bdftopcf, mkfontdir, mkfontscale }:

stdenv.mkDerivation rec {
  version = "1.3";
  name = "uw-ttyp0-${version}";

  src = fetchurl {
    url = "https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/${name}.tar.gz";
    sha256 = "1vp053bwv8sr40p3pn4sjaiq570zp7knh99z9ynk30v7ml4cz2i8";
  };

  nativeBuildInputs = [ perl mkfontdir bdftopcf ];

  postConfigure =
    ''
    echo "COPYTO AccStress PApostropheAscii" >> VARIANTS.dat
    echo "COPYTO PAmComma AccGraveAscii" >> VARIANTS.dat
    echo "COPYTO Digit0Slashed Digit0" >> VARIANTS.dat
    echo "COPYTO MTilde AccTildeAscii" >> VARIANTS.dat
    echo "COPYTO Space SpaceNoBreak" >> VARIANTS.dat
    echo "COPYTO PHyphenMinus PHyphenSoft" >> VARIANTS.dat
    '';

  meta = with stdenv.lib; {
    description = "Monospace Bitmap Screen Fonts for X11";
    homepage = https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/;
    downloadPage = https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/;
    license = licenses.mit;
  };
}
