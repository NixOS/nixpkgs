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
  version = "3.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-crRpUN+jZC3xx7hzz6eKVIUzckuQdHjFZ9tC/fV+49I=";
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
