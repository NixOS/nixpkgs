{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "4.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "33cd704aea07b4c28b3eb2c97d288a06918275dac0ecebdaf1bc8a48d98adb9e";
  };

  meta = {
    homepage = https://pypi.python.org/pypi/decorator;
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
  };
}