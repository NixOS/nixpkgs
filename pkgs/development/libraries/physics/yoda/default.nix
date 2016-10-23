{ stdenv, fetchurl, python2Packages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "yoda-${version}";
  version = "1.6.5";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    sha256 = "1i8lmj63cd3qnxl9k2cb1abap2pirhx7ffinm834wbpy9iszwxql";
  };

  pythonPath = []; # python wrapper support

  buildInputs = with python2Packages; [ python numpy matplotlib makeWrapper ];

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
