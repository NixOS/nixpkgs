{ lib
, buildPythonPackage
, fetchPypi
, numpy
, python
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a03e8511db603c57ca80dee851c43f08d0457f4d592bcac2e154570756cb934";
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