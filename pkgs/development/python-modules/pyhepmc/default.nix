{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, fetchurl
, pkgs
, python
}:

buildPythonPackage rec {
  pname = "pyhepmc";
  version = "0.5.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rbi8gqgclfvaibv9kzhfis11gw101x8amc93qf9y08ny4jfyr1d";
  };

  patches = [
    # merge PR https://bitbucket.org/andybuckley/pyhepmc/pull-requests/1/add-incoming-outgoing-generators-for/diff
    ./pyhepmc_export_edges.patch
    # add bindings to Flow class
    ./pyhepmc_export_flow.patch
  ];

  # regenerate python wrapper
  preConfigure = ''
    rm hepmc/hepmcwrap.py
    swig -c++ -I${pkgs.hepmc}/include -python hepmc/hepmcwrap.i
  '';

  buildInputs = [ pkgs.swig pkgs.hepmc ];

  HEPMCPATH = pkgs.hepmc;

  checkPhase = ''
    ${python.interpreter} test/test1.py
  '';

  meta = with stdenv.lib; {
    description = "A simple wrapper on the main classes of the HepMC event simulation representation, making it possible to create, read and manipulate HepMC events from Python code";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ veprbl ];
  };

}
