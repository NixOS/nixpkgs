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
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-eiswarnung";
    rev = "refs/tags/v${version}";
    hash = "sha256-sMR16if2Q+lK+ilnVNYVootBN2LFwBQLlZFkoX+oS/g=";
  };

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
