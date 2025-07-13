{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  pythonOlder,
  requests,
  robotframework,
}:

buildPythonPackage rec {
  pname = "robotframework-requests";
  version = "0.9.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "robotframework-requests";
    tag = "v${version}";
    hash = "sha256-NRhf3delcqUw9vWRPL6pJzpcmRMDou2pHmUHMstF8hw=";
  };

  propagatedBuildInputs = [
    lxml
    requests
    robotframework
  ];

  buildInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "RequestsLibrary" ];

  enabledTestPaths = [ "utests" ];

  meta = with lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
    maintainers = [ ];
  };
}
