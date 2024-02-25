{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-qld-bushfire-alert-client";
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-qld-bushfire-alert-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-ajCw1m7Qm1kZE/hOsBzFXPWAxl/pFD8pOOQo6qvachE=";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "georss_qld_bushfire_alert_client"
  ];

  meta = with lib; {
    description = "Python library for accessing Queensland Bushfire Alert feed";
    homepage = "https://github.com/exxamalte/python-georss-qld-bushfire-alert-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
