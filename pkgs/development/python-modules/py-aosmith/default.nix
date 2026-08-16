{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  tenacity,
}:

buildPythonPackage rec {
  pname = "py-aosmith";
  version = "1.0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdr99";
    repo = "py-aosmith";
    tag = version;
    hash = "sha256-sR7yUl97MlxdJHLrA8IjODNk7LJhVxqraaUkPljuMZg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    tenacity
  ];

  pythonImportsCheck = [ "py_aosmith" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Python client library for A. O. Smith water heaters";
    homepage = "https://github.com/bdr99/py-aosmith";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
