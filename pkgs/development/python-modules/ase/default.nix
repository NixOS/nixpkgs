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
  version = "3.19.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8378ab57e91cfe1ba09b3639d8409bb7fc1a40b59479c7822d206e673ad93f9";
  };

  propagatedBuildInputs = [ numpy scipy matplotlib flask pillow psycopg2 ];

  checkPhase = ''
    $out/bin/ase test
  '';

  # tests just hang most likely due to something with subprocesses and cli
  doCheck = false;

  meta = with lib; {
    description = "Atomic Simulation Environment";
    homepage = https://wiki.fysik.dtu.dk/ase/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ costrouc ];
  };
}
