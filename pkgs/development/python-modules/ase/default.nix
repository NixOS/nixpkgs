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
  version = "3.19.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "03xzpmpask2q2609kkq0hfgzsfvkyjpbjws7qx00nnfrbbnjk443";
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
