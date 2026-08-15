{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "georss-generic-client";
  version = "2026.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-generic-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1sEDkME4x0SK+5H9uenjfFDhnLUxUJMNEmtTx+VZ2I4=";
  };

  build-system = [ setuptools ];

  dependencies = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_generic_client" ];

  meta = {
    description = "Python library for accessing generic GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-georss-generic-client";
    changelog = "https://github.com/exxamalte/python-georss-generic-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
