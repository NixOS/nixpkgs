{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  tenacity,
}:

buildPythonPackage rec {
  pname = "py-aosmith";
  version = "1.0.10";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bdr99";
    repo = "py-aosmith";
    rev = "refs/tags/${version}";
    hash = "sha256-6wgPj3e3nbv0LM4qgZsj70F4nKy9LmY3RCvs++n1KbE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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
