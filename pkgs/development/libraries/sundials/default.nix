{ cmake, fetchurl, python, stdenv }:

stdenv.mkDerivation rec {

  pname = "sundials";
  version = "4.0.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
    sha256 = "1m5f2glxmgc6imjr0yqqp448r8q3kvsfp8dxxn83k00fcb40kr19";
  };

  preConfigure = ''
    export cmakeFlags="-DCMAKE_INSTALL_PREFIX=$out -DEXAMPLES_INSTALL_PATH=$out/share/examples $cmakeFlags"
  '';
  
  nativeBuildInputs = [ cmake ];
  buildInputs = [ python ];

  meta = with stdenv.lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage    = https://computation.llnl.gov/projects/sundials;
    platforms   = platforms.all;
    maintainers = [ maintainers.idontgetoutmuch ];
    license     = licenses.bsd3;
  };

}
