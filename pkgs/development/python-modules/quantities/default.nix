{ lib
, buildPythonPackage
, fetchPypi
, numpy
, python
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "582f3c7aeba897846761e966615e01202a5e5d06add304492931b05085d19883";
  };

  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    ${python.interpreter} setup.py test -V 1
  '';

  meta = {
    description = "Quantities is designed to handle arithmetic and";
    homepage = https://python-quantities.readthedocs.io/;
    license = lib.licenses.bsd2;
  };
}
