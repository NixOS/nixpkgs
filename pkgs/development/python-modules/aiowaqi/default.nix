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
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-waqi";
    rev = "refs/tags/v${version}";
    hash = "sha256-wwpktevEh/ukb9ByV660BePyqYU49/W+lIcgXuEBcuQ=";
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
