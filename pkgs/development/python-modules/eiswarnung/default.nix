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
  pname = "eiswarnung";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-eiswarnung";
    rev = "v${version}";
    hash = "sha256-Cw/xRypErasdrOZJ/0dWLl4eYH01vBI9mYm98teIdRc=";
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
    "eiswarnung"
  ];

  meta = with lib; {
    description = "Module for getting Eiswarning API forecasts";
    homepage = "https://github.com/klaasnicolaas/python-eiswarnung";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
