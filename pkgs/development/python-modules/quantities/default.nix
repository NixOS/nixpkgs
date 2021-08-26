{ lib
, buildPythonPackage
, fetchPypi
, numpy
, python
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.12.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67546963cb2a519b1a4aa43d132ef754360268e5d551b43dd1716903d99812f0";
  };

  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    ${python.interpreter} setup.py test -V 1
  '';

  meta = {
    description = "Quantities is designed to handle arithmetic and";
    homepage = "https://python-quantities.readthedocs.io/";
    license = lib.licenses.bsd2;
  };
}
