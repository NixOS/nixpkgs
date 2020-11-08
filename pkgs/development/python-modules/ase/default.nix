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
  version = "3.20.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "72c81f21b6adb907595fce8d883c0231301cbd8e9f6e5ce8e98bab927054daca";
  };

  requiredPythonModules = [ numpy scipy matplotlib flask pillow psycopg2 ];

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
