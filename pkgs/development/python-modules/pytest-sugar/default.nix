{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  termcolor,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c7i2UWPr8Q+fZx76ue7T1W8g0spovag/pkdAqSwI9l0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    termcolor
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Plugin that changes the default look and feel of pytest";
    homepage = "https://github.com/Frozenball/pytest-sugar";
    changelog = "https://github.com/Teemu/pytest-sugar/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
