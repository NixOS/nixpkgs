{ lib
, aiohttp
, buildPythonPackage
, codecov
, fetchFromGitHub
, iso4217
, poetry-core
, poetry-dynamic-versioning
, pytest-asyncio
, pythonOlder
, pytz
, types-pytz
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
  ];

  dependencies = [
    aiohttp
    codecov
    iso4217
    pytz
    types-pytz
  ];

  # Tests require network access
  doCheck  =false;

  pythonImportsCheck = [
    "pyefergy"
  ];

  meta = with lib; {
    description = "Python API library for Efergy energy meters";
    homepage = "https://github.com/tkdrob/pyefergy";
    changelog = "https://github.com/tkdrob/pyefergy/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
