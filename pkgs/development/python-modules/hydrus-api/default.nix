{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "hydrus-api";
  version = "5.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "hydrus_api";
    inherit version;
    hash = "sha256-oA3DbdX+MRZiInCKXurBdKlUFQ4jeU+jHr9NxMEHQmI=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "hydrus_api" ];

  # There are no unit tests
  doCheck = false;

  meta = with lib; {
    description = "Python module implementing the Hydrus API";
    homepage = "https://gitlab.com/cryzed/hydrus-api";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
