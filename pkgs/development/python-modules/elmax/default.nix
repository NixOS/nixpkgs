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
  version = "0.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-elmax";
    rev = version;
    sha256 = "0np3ixw8khrzb7hd8ly8xv349vnas0myfv9s0ahic58r1l9lcwa4";
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
