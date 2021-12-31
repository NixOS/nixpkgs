{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
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

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "p1monitor" ];

  meta = with lib; {
    description = "Python client for the P1 Monitor";
    homepage = "https://github.com/klaasnicolaas/python-p1monitor";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
