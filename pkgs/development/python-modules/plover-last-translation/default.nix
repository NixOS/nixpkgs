{
  lib,
  fetchPypi,
  python3Packages,
  plover,
  setuptools,
  pythonImportsCheckHook,
}:
python3Packages.buildPythonPackage rec {
  pname = "plover-last-translation";
  version = "0.0.2";
  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    description = "Macro plugins for Plover to repeat output";
    maintainers = with maintainers; [ twey ];
    license = licenses.gpl2Plus;
  };

  src = fetchPypi {
    pname = "plover_last_translation";
    inherit version;
    hash = "sha256-lmgjbuwdqZ8eeU4m/d1akFwwj5CmliEaLmXEKAubjdk=";
  };

  nativeCheckInputs = [
    pythonImportsCheckHook
  ];

  propagatedBuildInputs = [ plover ];
}
