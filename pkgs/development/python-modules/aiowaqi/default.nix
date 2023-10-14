{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, syrupy
, yarl
}:

buildPythonPackage rec {
  pname = "aiowaqi";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-waqi";
    rev = "refs/tags/v${version}";
    hash = "sha256-WEcCv4PCJ1gmRkQbjhIxx8qi1zps2Z65iFrdBHXPPvA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" ""
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
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [
    "aiowaqi"
  ];

  meta = with lib; {
    description = "Module to interact with the WAQI API";
    homepage = "https://github.com/joostlek/python-waqi";
    changelog = "https://github.com/joostlek/python-waqi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
