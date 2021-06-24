{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "elmax";
  version = "0.1.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-elmax";
    rev = version;
    sha256 = "sha256-vDISJ/CVOjpM+GPF2TCm3/AMFTWTM0b/+ZPCpAEvNvY=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    httpx
    yarl
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "elmax" ];

  meta = with lib; {
    description = "Python API client for the Elmax Cloud services";
    homepage = "https://github.com/home-assistant-ecosystem/python-elmax";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
