{ stdenv, fetchpatch, fetchurl, boost, fastjet, gfortran, gsl, lhapdf, thepeg, zlib, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "herwig-${version}";
  version = "7.0.3";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/herwig/Herwig-${version}.tar.bz2";
    sha256 = "0v7b84n0v3dhjpx0vfk5p8g87kivgg9svfivnih1yrfm749269m2";
  };

  patches = [
    # Otherwise it causes an error
    # lib/Herwig/HwMatchboxScales.so: undefined symbol: _Z8renScaleSt6vectorIN6ThePEG14Lorentz5VectorIdEESaIS2_EES4_S4_
    (fetchpatch {
      url = "https://herwig.hepforge.org/hg/herwig/rev/fe543583fa02?style=raw";
      sha256 = "1y6a9q93wicw3c73xni74w5k25vidgcr60ffi2b2ymhb390jas83";
    })
  ];

  nativeBuildInputs = [ autoconf automake libtool ];

  buildInputs = [ boost fastjet gfortran gsl thepeg zlib ]
    # There is a bug that requires for MMHT PDF's to be presend during the build
    ++ (with lhapdf.pdf_sets; [ MMHT2014lo68cl MMHT2014nlo68cl ]);

  preConfigure = ''
    # needed for the patch above
    autoreconf -i
  '';

  configureFlags = [
    "--with-thepeg=${thepeg}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A multi-purpose particle physics event generator";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://herwig.hepforge.org/;
    platforms   = [ "x86_64-darwin" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
