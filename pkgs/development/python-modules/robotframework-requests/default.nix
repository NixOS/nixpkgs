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
  version = "1.0a14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "robotframework-requests";
    tag = "v${version}";
    hash = "sha256-5iqrFUHC4T2mJ8voiMItmlT2gpkUlJs1Et4udTPbtCs=";
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
