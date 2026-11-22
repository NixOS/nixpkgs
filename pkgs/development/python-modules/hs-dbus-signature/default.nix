{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "hs-dbus-signature";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mulkieran";
    repo = "hs-dbus-signature";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A9+v9xO8Ne+u48Fj4Njml4V4T0alXqpkwuB6/cH3av4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    hypothesis
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hs_dbus_signature" ];

  meta = {
    description = "Hypothesis Strategy for Generating Arbitrary DBus Signatures";
    homepage = "https://github.com/mulkieran/hs-dbus-signature";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
