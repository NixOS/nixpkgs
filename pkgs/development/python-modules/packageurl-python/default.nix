{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.17.5";
  pyproject = true;

  src = fetchPypi {
    pname = "packageurl_python";
    inherit version;
    hash = "sha256-p74/O6cNcF9zis6b9hJPMZICRaSfpp1LQW2nA33S3mE=";
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
