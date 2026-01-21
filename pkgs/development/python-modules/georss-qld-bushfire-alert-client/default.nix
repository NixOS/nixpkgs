{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "georss-qld-bushfire-alert-client";
  version = "0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-qld-bushfire-alert-client";
    tag = "v${version}";
    hash = "sha256-/MyjYLu29PANe17KxJCkmHPjvjlPfswn7ZBAKFSwohc=";
  };

  build-system = [ setuptools ];

  dependencies = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_qld_bushfire_alert_client" ];

  meta = {
    description = "Python library for accessing Queensland Bushfire Alert feed";
    homepage = "https://github.com/exxamalte/python-georss-qld-bushfire-alert-client";
    changelog = "https://github.com/exxamalte/python-georss-qld-bushfire-alert-client/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
