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
  version = "1.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdr99";
    repo = "py-aosmith";
    tag = version;
    hash = "sha256-ESdTEzT9JYtGTus2VUIOF72BwuuUr4rMv/ID7Nr8FR0=";
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
