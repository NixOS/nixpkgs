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
  version = "1.0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdr99";
    repo = "py-aosmith";
    tag = version;
    hash = "sha256-qBnHe4w59QW18osEf+9Y46eEx/W/GzARkwJlJ+9wPr0=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "tenacity" ];

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
