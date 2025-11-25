{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "rjsmin";
  version = "1.2.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o/gECwJz3sdz4OgH6GpNCpU1UWwKCjWqG7bebhW7Hwk=";
  };

  # The package does not ship tests, and the setup machinery confuses
  # tests auto-discovery
  doCheck = false;

  pythonImportsCheck = [ "rjsmin" ];

  meta = with lib; {
    description = "Module to minify Javascript";
    homepage = "http://opensource.perlig.de/rjsmin/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
