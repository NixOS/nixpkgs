{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  pythonRelaxDepsHook,
  iso4217,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "pyefergy";
  version = "22.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = "pyefergy";
    rev = "refs/tags/v${version}";
    hash = "sha256-4M3r/+C42X95/7BGZAJbkXKKFEkGzLlvX0Ynv+eL8qc=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    "codecov"
    "types-pytz"
  ];

  dependencies = [
    aiohttp
    iso4217
    pytz
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pyefergy" ];

  meta = with lib; {
    changelog = "https://github.com/tkdrob/pyefergy/releases/tag/v${version}";
    description = "Python API library for Efergy energy meters";
    homepage = "https://github.com/tkdrob/pyefergy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
