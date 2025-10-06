{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  xmltodict,
  urllib3,
}:

buildPythonPackage rec {
  pname = "greenwavereality";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bNTO9qHoOe3A7TYiUwLBVq4eWyGoIfCoguizM1hKk/Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    xmltodict
    urllib3
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "greenwavereality" ];

  meta = {
    description = "Control of Greenwave Reality Lights";
    homepage = "https://github.com/dfiel/greenwavereality";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
