{ stdenv, fetchurl, python2Packages, root, makeWrapper }:

stdenv.mkDerivation rec {
  name = "yoda-${version}";
  version = "1.6.6";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    sha256 = "088xx4q6b03bnj6xg5189m8wsznhal8aj3jk40sbj24idm4jl5yg";
  };

  pythonPath = []; # python wrapper support

  buildInputs = with python2Packages; [ python numpy matplotlib root makeWrapper ];

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
