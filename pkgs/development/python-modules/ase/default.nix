{ lib
, fetchPypi
, buildPythonPackage
, isPy27
, numpy
, scipy
, matplotlib
, flask
, pillow
, psycopg2
}:

buildPythonPackage rec {
  pname = "ase";
  version = "3.21.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c561e9b767cf16fc8ce198ea9326d77c6b67d33a85f44b68455e23466a64608";
  };

  propagatedBuildInputs = [ numpy scipy matplotlib flask pillow psycopg2 ];

  checkPhase = ''
    $out/bin/ase test
  '';

  # tests just hang most likely due to something with subprocesses and cli
  doCheck = false;

  meta = with lib; {
    description = "Atomic Simulation Environment";
    homepage = "https://wiki.fysik.dtu.dk/ase/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ costrouc ];
  };
}
