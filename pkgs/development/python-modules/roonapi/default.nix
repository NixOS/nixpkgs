{ lib
, buildPythonPackage
, fetchFromGitHub
, ifaddr
, poetry-core
, pythonOlder
, requests
, six
, websocket-client
}:

buildPythonPackage rec {
  pname = "roonapi";
  version = "0.0.38";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pavoni";
    repo = "pyroon";
    rev = version;
    sha256 = "sha256-vXx7MgoGjBPdx7uKUtAVqlXphPJYt5SyuTo2JlKia60=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    ifaddr
    requests
    six
    websocket-client
  ];

  # Tests require access to the Roon API
  doCheck = false;

  pythonImportsCheck = [ "roonapi" ];

  meta = with lib; {
    description = "Python library to interface with the Roon API";
    homepage = "https://github.com/pavoni/pyroon";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
