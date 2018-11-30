{ lib
, buildPythonPackage
, fetchPypi
, numpy
, python
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "92e8397938516483f4fd1855097ec11953ab10dd0bf3293954559226679f76f0";
  };

  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    ${python.interpreter} setup.py test -V 1
  '';

  meta = {
    description = "Quantities is designed to handle arithmetic and";
    homepage = http://python-quantities.readthedocs.io/;
    license = lib.licenses.bsd2;
  };
}