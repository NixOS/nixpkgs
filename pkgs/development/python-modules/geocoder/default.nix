{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  future,
  ratelim,
  requests,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "geocoder";
  version = "1.38.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yZJTdMlhV30K7kA7Ceb46hlx2RPwEfAMpwx2vq96d+c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    future
    ratelim
    requests
    six
  ];

  pythonImportsCheck = [ "geocoder" ];

  meta = {
    description = "Module for geocoding";
    homepage = "https://pypi.org/project/geocoder/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
