{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "georss-qld-bushfire-alert-client";
  version = "0.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-qld-bushfire-alert-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-ajCw1m7Qm1kZE/hOsBzFXPWAxl/pFD8pOOQo6qvachE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_qld_bushfire_alert_client" ];

  meta = with lib; {
    description = "Python library for accessing Queensland Bushfire Alert feed";
    homepage = "https://github.com/exxamalte/python-georss-qld-bushfire-alert-client";
    changelog = "https://github.com/exxamalte/python-georss-qld-bushfire-alert-client/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
