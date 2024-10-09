{
  lib,
  fetchPypi,
  python3Packages,
  plover,
  setuptools,
  pytestCheckHook,
  pythonImportsCheckHook,
}:
python3Packages.buildPythonPackage rec {
  pname = "plover-python-dictionary";
  version = "1.1.0";
  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    description = "Add support for Python dictionaries to Plover.";
    maintainers = with maintainers; [ twey ];
    license = licenses.gpl2Plus;
  };

  src = fetchPypi {
    pname = "plover_python_dictionary";
    inherit version;
    hash = "sha256-YlHTmMtKWUadObGbsrsF+PUspCB4Kr+amy57DQ4eCQs=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pythonImportsCheckHook
  ];

  propagatedBuildInputs = [ plover ];
}
