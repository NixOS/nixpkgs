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
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-p1monitor";
    rev = "v${version}";
    sha256 = "0jpx66b9fy87px54b5wws91qk27rqfcsmlswapz01n05d01sqy43";
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
