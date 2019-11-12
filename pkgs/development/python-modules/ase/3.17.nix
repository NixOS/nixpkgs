{ lib
, fetchPypi
, buildPythonPackage
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

  src = fetchPypi {
    inherit pname version;
    sha256 = "e21948dbf79011cc796d772885a8aafb255a6f365d112fe6a3bd26198c6cac7f";
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
