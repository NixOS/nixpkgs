{
  lib,
  fetchPypi,
  python3Packages,
  plover,
  setuptools,
  pythonImportsCheckHook,
}:
python3Packages.buildPythonPackage rec {
  pname = "plover-modal-dictionary";
  version = "0.0.3";
  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    description = "Modal Dictionaries for Plover";
    maintainers = with maintainers; [ twey ];
    license = licenses.gpl2Plus;
  };

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qLr5H6ZvPhzG4Wa6dK45iReABO0EvA5+2afp2ctnc1A=";
  };

  nativeCheckInputs = [
    pythonImportsCheckHook
  ];

  propagatedBuildInputs = [ plover ];
}
