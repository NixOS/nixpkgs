{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d46dd9f3ea1cf5f06ee0e4e1277ae618cf48dfb10ada7c8427cd46c42702a0e";
  };

  meta = {
    homepage = https://pypi.python.org/pypi/decorator;
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
  };
}