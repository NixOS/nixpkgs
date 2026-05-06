{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "hydrus-api";
  version = "5.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "hydrus_api";
    inherit version;
    hash = "sha256-5MVyKiAHdjOOVHTyX6xdqRnvlSChAnm6hPzf1YVW2+8=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "hydrus_api" ];

  # There are no unit tests
  doCheck = false;

  meta = {
    description = "Python module implementing the Hydrus API";
    homepage = "https://gitlab.com/cryzed/hydrus-api";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
