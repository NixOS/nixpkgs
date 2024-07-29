{
  lib,
  buildPythonPackage,
  cython,
  enum34,
  fetchPypi,
  nine,
  numpy,
  pytestCheckHook,
  python-utils,
}:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "3.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-947qYsgJOL9T6pFPpbbJL0SPDqtWCeDlpzfd4DlAQzQ=";
  };

  propagatedBuildInputs = [
    cython
    enum34
    nine
    numpy
    python-utils
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stl" ];

  meta = with lib; {
    description = "Library to make reading, writing and modifying both binary and ascii STL files easy";
    homepage = "https://github.com/WoLpH/numpy-stl/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
