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
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pavoni";
    repo = "pyroon";
    rev = version;
    sha256 = "sha256-GEgm250uALTXIEMBWmluqGw/dw2TfGmUIcItfzonGkU=";
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

  pythonImportsCheck = [
    "roonapi"
  ];

  meta = with lib; {
    description = "Python library to interface with the Roon API";
    homepage = "https://github.com/pavoni/pyroon";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
