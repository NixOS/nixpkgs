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
  pname = "p1monitor";
  version = "2.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-p1monitor";
    rev = "refs/tags/v${version}";
    hash = "sha256-2NlFXeI+6ooh4D1OxUWwYrmM4zpL9gg8vhnseLjj2dM=";
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
    "p1monitor"
  ];

  meta = with lib; {
    description = "Module for interacting with the P1 Monitor";
    homepage = "https://github.com/klaasnicolaas/python-p1monitor";
    changelog = "https://github.com/klaasnicolaas/python-p1monitor/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
