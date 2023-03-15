{ lib
, buildPythonPackage
, cython
, enum34
, fetchPypi
, nine
, numpy
, pytestCheckHook
, python-utils
}:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-V4t46ssFKayaui8X3MNj1Yx8PFcIcQwY+MHpll8ugaw=";
  };

  propagatedBuildInputs = [
    cython
    enum34
    nine
    numpy
    python-utils
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "stl" ];

  meta = with lib; {
    description = "Library to make reading, writing and modifying both binary and ascii STL files easy";
    homepage = "https://github.com/WoLpH/numpy-stl/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
