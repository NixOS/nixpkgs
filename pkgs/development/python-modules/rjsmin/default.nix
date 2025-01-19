{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "rjsmin";
  version = "1.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E4i1JJOkwE+8lwotdXwwH6BaPDdkAxTCzp38jYpzDMY=";
  };

  # The package does not ship tests, and the setup machinary confuses
  # tests auto-discovery
  doCheck = false;

  pythonImportsCheck = [ "rjsmin" ];

  meta = {
    description = "Module to minify Javascript";
    homepage = "http://opensource.perlig.de/rjsmin/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
