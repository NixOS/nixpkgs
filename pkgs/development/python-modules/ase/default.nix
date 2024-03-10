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
  version = "3.22.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AE32sOoEsRFMeQ+t/kXUEl6w5TElxmqTQlr4U9gqtDI=";
  };

  propagatedBuildInputs = [ numpy scipy matplotlib flask pillow psycopg2 ];

  checkPhase = ''
    $out/bin/ase test
  '';

  # tests just hang most likely due to something with subprocesses and cli
  doCheck = false;

  pythonImportsCheck = [ "ase" ];

  meta = with lib; {
    description = "Atomic Simulation Environment";
    homepage = "https://wiki.fysik.dtu.dk/ase/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
