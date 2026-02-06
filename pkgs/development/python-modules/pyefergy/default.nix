{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  iso4217,
  pytz,
}:

buildPythonPackage rec {
  pname = "pyefergy";
  version = "22.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = "pyefergy";
    tag = "v${version}";
    hash = "sha256-4M3r/+C42X95/7BGZAJbkXKKFEkGzLlvX0Ynv+eL8qc=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
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

  meta = {
    changelog = "https://github.com/tkdrob/pyefergy/releases/tag/v${version}";
    description = "Python API library for Efergy energy meters";
    homepage = "https://github.com/tkdrob/pyefergy";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
