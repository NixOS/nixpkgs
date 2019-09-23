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
  version = "3.18.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ycp1yksysiiz902gn762030sfmirxm950pwpw2rcrpjvq95zm1r";
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
