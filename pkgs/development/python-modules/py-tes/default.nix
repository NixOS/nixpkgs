{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  python-dateutil,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
  sphinx-rtd-theme,
}:

buildPythonPackage rec {
  pname = "py-tes";
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ohsu-comp-bio";
    repo = "py-tes";
    tag = version;
    hash = "sha256-hZF4koc/nZ8rBYKfhIQCLtn4DKiljJrSBgkKX8bMoQ0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    future
    python-dateutil
    requests
    sphinx-rtd-theme
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "tes" ];

  disabledTestPaths = [
    # Tests require running funnel
    "tests/integration"
  ];

  meta = with lib; {
    description = "Python SDK for the GA4GH Task Execution API";
    homepage = "https://github.com/ohsu-comp-bio/py-tes";
    changelog = "https://github.com/ohsu-comp-bio/py-tes/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
