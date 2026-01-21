{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.17.6";
  pyproject = true;

  src = fetchPypi {
    pname = "packageurl_python";
    inherit version;
    hash = "sha256-ElLOOhAjcspvhuuWjhb5AUxLpRHFw32Vp/Aj4spuXCU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "packageurl" ];

  meta = {
    description = "Python parser and builder for package URLs";
    homepage = "https://github.com/package-url/packageurl-python";
    changelog = "https://github.com/package-url/packageurl-python/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ armijnhemel ];
  };
}
