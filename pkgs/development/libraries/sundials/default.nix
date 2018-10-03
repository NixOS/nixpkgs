{ cmake, fetchurl, python, stdenv }:

stdenv.mkDerivation rec {

  pname = "sundials";
  version = "3.2.0";
  name = "${pname}-${version}";

  src = fetchurl {
  url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
  sha256 = "1yck1qjw5pw5i58x762vc0adg4g53lsan9xv92hbby5dxjpr1dnj";
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
