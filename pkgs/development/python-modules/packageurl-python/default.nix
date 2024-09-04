{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.15.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "packageurl_python";
    inherit version;
    hash = "sha256-y8ia/RXV9NBdtPG2EpfluXpD9h8oeZ9tKCr/Rn7S7pY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "packageurl" ];

  meta = with lib; {
    description = "Python parser and builder for package URLs";
    homepage = "https://github.com/package-url/packageurl-python";
    changelog = "https://github.com/package-url/packageurl-python/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ armijnhemel ];
  };
}
