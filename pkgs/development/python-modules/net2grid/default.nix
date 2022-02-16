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
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-net2grid";
    rev = "v${version}";
    hash = "sha256-2hjWQaktx7XUS7gf7A+9QNSZSujyVZUka/SwEnEu2dg=";
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
