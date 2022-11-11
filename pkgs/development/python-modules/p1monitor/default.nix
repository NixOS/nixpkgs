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
  version = "2.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-p1monitor";
    rev = "refs/tags/v${version}";
    hash = "sha256-VHY5AWxt5BZd1NQKzsgubEZBLKAlDNm8toyEazPUnDU=";
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
    "p1monitor"
  ];

  meta = with lib; {
    description = "Module for interacting with the P1 Monitor";
    homepage = "https://github.com/klaasnicolaas/python-p1monitor";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
