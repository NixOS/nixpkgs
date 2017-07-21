{ stdenv, fetchurl, fetchpatch, python2Packages, root, makeWrapper, withRootSupport ? false }:

stdenv.mkDerivation rec {
  name = "yoda-${version}";
  version = "1.6.7";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    sha256 = "05jyv5dypa6d4q1m8wm2qycgq1i0bgzwzzm9qqdj0b43ff2kggra";
  };

  pythonPath = []; # python wrapper support

  buildInputs = with python2Packages; [ python numpy matplotlib makeWrapper ]
    ++ stdenv.lib.optional withRootSupport root;

  enableParallelBuilding = true;

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://yoda.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
