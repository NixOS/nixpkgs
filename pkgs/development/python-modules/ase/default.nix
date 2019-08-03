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
  version = "3.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d4gxypaahby45zcpl0rffcn2z7n55dg9lcd8sv6jjsmbbf9vr4g";
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
