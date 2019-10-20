{ stdenv, fetchurl, gfortran, hoppet, lhapdf, root5 }:

stdenv.mkDerivation rec {
  pname = "applgrid";
  version = "1.4.70";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/applgrid/${pname}-${version}.tgz";
    sha256 = "1yw9wrk3vjv84kd3j4s1scfhinirknwk6xq0hvj7x2srx3h93q9p";
  };

  buildInputs = [ gfortran hoppet lhapdf root5 ];

  patches = [
    ./bad_code.patch
  ];

  preConfigure = ''
    substituteInPlace src/Makefile.in \
      --replace "-L\$(subst /libgfortran.a, ,\$(FRTLIB) )" "-L${gfortran.cc.lib}/lib"
  '' + (if stdenv.isDarwin then ''
    substituteInPlace src/Makefile.in \
      --replace "gfortran -print-file-name=libgfortran.a" "gfortran -print-file-name=libgfortran.dylib"
  '' else "");

  enableParallelBuilding = false; # broken

  # Install private headers required by APFELgrid
  postInstall = ''
    for header in src/*.h; do
      install -Dm644 "$header" "$out"/include/appl_grid/"`basename $header`"
    done
  '';

  meta = with stdenv.lib; {
    description = "The APPLgrid project provides a fast and flexible way to reproduce the results of full NLO calculations with any input parton distribution set in only a few milliseconds rather than the weeks normally required to gain adequate statistics";
    license     = licenses.gpl3;
    homepage    = http://applgrid.hepforge.org;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
