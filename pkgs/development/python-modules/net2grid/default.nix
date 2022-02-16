{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "net2grid";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-net2grid";
    rev = "v${version}";
    hash = "sha256-nT9qMv4Zr7SjNwHRN3HRR11yl+Oue8VVCfJr2n1D02Q=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"' \
      --replace 'addopts = "--cov"' ""
  '';

  pythonImportsCheck = [
    "net2grid"
  ];

  meta = with lib; {
    description = "Module for interacting with NET2GRID devices";
    homepage = "https://github.com/klaasnicolaas/python-net2grid";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
