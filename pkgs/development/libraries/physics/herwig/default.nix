{ stdenv, fetchurl, boost, fastjet, gfortran, gsl, lhapdf, thepeg, zlib, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "herwig";
  version = "7.1.6";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/herwig/Herwig-${version}.tar.bz2";
    sha256 = "0h4gcmwnk4iyd31agzcq3p8bvlrgc8svm4ymzqgvvhizwflqf3yr";
  };

  nativeBuildInputs = [ autoconf automake libtool ];

  buildInputs = [ boost fastjet gfortran gsl thepeg zlib ]
    # There is a bug that requires for MMHT PDF's to be presend during the build
    ++ (with lhapdf.pdf_sets; [ MMHT2014lo68cl MMHT2014nlo68cl ]);

  postPatch = ''
    patchShebangs ./
  '';

  configureFlags = [
    "--with-thepeg=${thepeg}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A multi-purpose particle physics event generator";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://herwig.hepforge.org/;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
    broken      = stdenv.isAarch64; # doesn't compile: ignoring return value of 'FILE* freopen...
  };
}
