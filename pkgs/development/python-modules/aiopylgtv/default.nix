{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  setuptools,
  sqlitedict,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiopylgtv";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bendavid";
    repo = "aiopylgtv";
    tag = finalAttrs.version;
    hash = "sha256-NkWJGy5QUrhpbARoscrXy/ilCjAz01YxeVTH0I+IjNM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    sqlitedict
    websockets
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "aiopylgtv" ];

  meta = {
    description = "Python library to control webOS based LG TV units";
    mainProgram = "aiopylgtvcommand";
    homepage = "https://github.com/bendavid/aiopylgtv";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
