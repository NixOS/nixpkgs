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
  version = "3.18.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zxcdj61j9mxlgk2y4ax6rpml9gvmal8aa3pdmwwq4chyzdlh6g2";
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
