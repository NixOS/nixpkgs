{ stdenv, fetchurl, doxygen }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "dirac-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/dirac/${name}.tar.gz";
    sha256 = "1z803yzp17cj69wn11iyb13swqdd9xdzr58dsk6ghpr3ipqicsw1";
  };

  buildInputs = [ doxygen ];
  enableParallelBuilding = true;

  patches = [ ./dirac-1.0.2.patch ];

  postInstall = ''
    # keep only necessary binaries
    find $out/bin \( -name '*RGB*' -or -name '*YUV*' -or -name create_dirac_testfile.pl \) -delete
  '';

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/projects/dirac;
    description = "A general-purpose video codec based on wavelets";
    platforms = platforms.all;
    license = with licenses; [ mpl11 gpl2 lgpl21 ];
    maintainer = maintainers.igsha;
  };
}
