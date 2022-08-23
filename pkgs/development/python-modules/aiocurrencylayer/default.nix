{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiocurrencylayer";
  version = "1.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = pname;
    rev = version;
    sha256 = "sha256-t2Pcoakk25vtUYajIZVITsrEUSdwwiA3fbdswy3n9P8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    httpx
  ];

  checkInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiocurrencylayer"
  ];

  meta = with lib; {
    description = "Python API for interacting with currencylayer";
    homepage = "https://github.com/home-assistant-ecosystem/aiocurrencylayer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
