{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "packageurl-python";
  version = "0.17.6";
  pyproject = true;

  src = fetchPypi {
    pname = "packageurl_python";
    inherit (finalAttrs) version;
    hash = "sha256-ElLOOhAjcspvhuuWjhb5AUxLpRHFw32Vp/Aj4spuXCU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # The specification test data is only available in the Git repository.
  disabledTestPaths = [ "tests/test_purl_spec.py" ];

  pythonImportsCheck = [ "packageurl" ];

  meta = {
    description = "Python parser and builder for package URLs";
    homepage = "https://github.com/package-url/packageurl-python";
    changelog = "https://github.com/package-url/packageurl-python/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ armijnhemel ];
  };
})
