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
  version = "0.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pavoni";
    repo = "pyroon";
    rev = version;
    hash = "sha256-TXIKa5DB5+511fQuHAQwPWqw7vQPP+s1X3U7BgEfzzE=";
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
    changelog = "https://github.com/pavoni/pyroon/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
