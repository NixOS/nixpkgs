{
  lib,
  buildPythonPackage,
  fetchPypi,
  jaraco-classes,
  jaraco-context,
  keyring,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "keyrings-alt";
  version = "5.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "keyrings.alt";
    inherit version;
    hash = "sha256-zTcqHsRGobxakGJKUsiOg7kzAhjjkEemyaSK430RZ0U=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    jaraco-classes
    jaraco-context
  ];

  nativeCheckInputs = [
    pytestCheckHook
    keyring
  ];

  pythonImportsCheck = [ "keyrings.alt" ];

  meta = with lib; {
    description = "Alternate keyring implementations";
    homepage = "https://github.com/jaraco/keyrings.alt";
    changelog = "https://github.com/jaraco/keyrings.alt/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ nyarly ];
  };
}
