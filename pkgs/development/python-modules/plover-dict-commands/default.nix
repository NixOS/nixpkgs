{
  lib,
  fetchPypi,
  python3Packages,
  plover,
  setuptools,
  setuptools-scm,
  pythonImportsCheckHook,
}:
python3Packages.buildPythonPackage rec {
  pname = "plover-dict-commands";
  version = "0.2.5";
  pyproject = true;
  build-system = [
    setuptools
    setuptools-scm
  ];

  meta = with lib; {
    description = "Plugin for enabling, disabling, and changing the priority of dictionaries in Plover";
    maintainers = with maintainers; [ twey ];
    license = licenses.gpl2Plus;
  };

  src = fetchPypi {
    pname = "plover_dict_commands";
    inherit version;
    hash = "sha256-ki/M5V106YbQMjZQmkTNyBzFboVYi/x0hkLAXqPyk8Q=";
  };

  nativeCheckInputs = [
    pythonImportsCheckHook
  ];

  propagatedBuildInputs = [ plover ];
}
