{ stdenv, fetchurl, fetchpatch, python2Packages, root, makeWrapper, zlib, withRootSupport ? false }:

stdenv.mkDerivation rec {
  name = "yoda-${version}";
  version = "1.7.0";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    sha256 = "0fyf6ld1klzlfmr5sl1jxzck4a0h14zfkrff8397rn1fqnqbzmmk";
  };

  pythonPath = []; # python wrapper support

  buildInputs = with python2Packages; [ python numpy matplotlib makeWrapper ]
    ++ stdenv.lib.optional withRootSupport root;
  propagatedBuildInputs = [ zlib ];

  enableParallelBuilding = true;

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  hardeningDisable = [ "format" ];

  meta = {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://yoda.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
