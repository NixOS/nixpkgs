{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  regex,
}:

buildPythonPackage rec {
  pname = "flatlatex";
  version = "0.15";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UXDhvNT8y1K9vf8wCxS2hzBIO8RvaiqJ964rsCTk0Tk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flatlatex"
  ];

  meta = {
    description = "LaTeX math converter to unicode text";
    homepage = "https://github.com/jb-leger/flatlatex";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      euxane
      renesat
    ];
  };
}
