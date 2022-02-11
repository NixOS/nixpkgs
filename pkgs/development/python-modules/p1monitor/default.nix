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
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-p1monitor";
    rev = "v${version}";
    sha256 = "1ciaclgq4aknldjqlqa08jcab28sbqrjxy5nqqwlnb2wlprg5ijz";
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

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "p1monitor" ];

  meta = with lib; {
    description = "Python client for the P1 Monitor";
    homepage = "https://github.com/klaasnicolaas/python-p1monitor";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
