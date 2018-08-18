{ cmake, fetchurl, python, stdenv }:

stdenv.mkDerivation rec {

  pname = "sundials";
  version = "3.1.2";
  name = "${pname}-${version}";

  src = fetchurl {
  url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
  sha256 = "05p19y3vv0vi3nggrvy6ymqkvhab2dxncl044qj0xnaix2qmp658";
  };

  preConfigure = ''
    export cmakeFlags="-DCMAKE_INSTALL_PREFIX=$out -DEXAMPLES_INSTALL_PATH=$out/share/examples $cmakeFlags"
  '';
  
  buildInputs = [ cmake python ];

  meta = with stdenv.lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage    = https://computation.llnl.gov/casc/sundials/main.html;
    platforms   = platforms.all;
    maintainers = [ maintainers.idontgetoutmuch ];
    license     = licenses.bsd3;
  };

}
