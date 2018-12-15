{ cmake, fetchurl, python, stdenv }:

stdenv.mkDerivation rec {

  pname = "sundials";
  version = "3.2.1";
  name = "${pname}-${version}";

  src = fetchurl {
  url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
  sha256 = "0238r1qnwqz13wcjzfsbcfi8rfnlxcjjmxq2vpf2qf5jgablvna7";
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
