{ stdenv, fetchurl, gfortran, lhapdf, root }:

stdenv.mkDerivation rec {
  name = "applgrid-${version}";
  version = "1.4.93";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/applgrid/${name}.tgz";
    sha256 = "04gpkj2yjvbj4plxjhf9dafndbb04wxl6jss5a2gn1hwzqaj9jk9";
  };

  buildInputs = [ gfortran lhapdf root ];

  preConfigure = ''
    substituteInPlace src/Makefile.in --replace "-L\$(subst /libgfortran.a, ,\$(FRTLIB) )" "-L${gfortran}/lib"
  '' + (if stdenv.isDarwin then ''
    substituteInPlace src/Makefile.in --replace "gfortran -print-file-name=libgfortran.a" "gfortran -print-file-name=libgfortran.dylib"
  '' else "");

  enableParallelBuilding = false; # broken

  meta = {
    description = "The APPLgrid project provides a fast and flexible way to reproduce the results of full NLO calculations with any input parton distribution set in only a few milliseconds rather than the weeks normally required to gain adequate statistics";
    license     = stdenv.lib.licenses.gpl3;
    homepage    = http://applgrid.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
