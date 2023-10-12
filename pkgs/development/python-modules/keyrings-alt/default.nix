{ lib
, buildPythonPackage
, fetchPypi
, jaraco-classes
, keyring
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "keyrings-alt";
  version = "5.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "keyrings.alt";
    inherit version;
    hash = "sha256-nURstHu86pD/ouzD6AA6z0FXP8IBv0S0vxO9DhFISCg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jaraco-classes
  ];

  nativeCheckInputs = [
    pytestCheckHook
    keyring
  ];

  pythonImportsCheck = [
    "keyrings.alt"
  ];

  meta = with lib; {
    description = "Alternate keyring implementations";
    homepage = "https://github.com/jaraco/keyrings.alt";
    changelog = "https://github.com/jaraco/keyrings.alt/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ nyarly ];
  };
}
