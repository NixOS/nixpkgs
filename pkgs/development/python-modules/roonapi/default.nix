{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ifaddr,
  poetry-core,
  requests,
  six,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "roonapi";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pavoni";
    repo = "pyroon";
    rev = version;
    hash = "sha256-6wQsaZ50J2xIPXzICglg5pf8U0r4tL8iqcbdwjZadwU=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    ifaddr
    requests
    six
    websocket-client
  ];

  # Tests require access to the Roon API
  doCheck = false;

  pythonImportsCheck = [ "roonapi" ];

  meta = {
    description = "Python library to interface with the Roon API";
    homepage = "https://github.com/pavoni/pyroon";
    changelog = "https://github.com/pavoni/pyroon/releases/tag/${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
