{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
  sphinx-rtd-theme,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-tes";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ohsu-comp-bio";
    repo = "py-tes";
    tag = finalAttrs.version;
    hash = "sha256-/xgycSDFp17rPzC6ICf4e+vrIKWYPftDngx/u1/KHWk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
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

  meta = {
    description = "Python SDK for the GA4GH Task Execution API";
    homepage = "https://github.com/ohsu-comp-bio/py-tes";
    changelog = "https://github.com/ohsu-comp-bio/py-tes/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
