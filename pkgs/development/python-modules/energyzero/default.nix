{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-freezer
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "energyzero";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-energyzero";
    rev = "refs/tags/v${version}";
    hash = "sha256-NZbCiLCZC+hTcV0twOeCoKKD3eZ0/ZzPTnVpFyMLSfw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"' \
      --replace 'addopts = "--cov"' ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-freezer
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "energyzero"
  ];

  meta = with lib; {
    description = "Module for getting the dynamic prices from EnergyZero";
    homepage = "https://github.com/klaasnicolaas/python-energyzero";
    changelog = "https://github.com/klaasnicolaas/python-energyzero/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
