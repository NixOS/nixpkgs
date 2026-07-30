{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pystalk";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "NUCCllxw4egR4OLUDv+c8D1ie67YnB8RjqZ2bXzepYE=";
  };

  build-system = [ setuptools ];

  doCheck = false; # no tests

  dependencies = [
    attrs
    pyyaml
  ];

  meta = {
    description = "Simple Python Beanstalkd client";
    homepage = "https://github.com/easypost/pystalk";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ jbcrail ];
  };
}
