{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "4.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7cb64d38cb8002971710c8899fbdfb859a23a364b7c99dab19d1f719c2ba16b5";
  };

  meta = {
    homepage = https://pypi.python.org/pypi/decorator;
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
  };
}