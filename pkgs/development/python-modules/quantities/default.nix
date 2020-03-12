{ lib
, buildPythonPackage
, fetchPypi
, numpy
, python
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.12.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12qx6cgib3wxmm2cvann4zw4jnhhn24ms61ifq9f3jbh31nn6gd3";
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
