{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colour";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ryASD+/Sr+3osAH77y6p2nCtfUn6/bZIkCXa6HRcOu4=";
  };

  patches = [
    # https://github.com/vaab/colour/pull/66 (but does not merge cleanly)
    ./remove-unmaintained-d2to1.diff
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--doctest-glob=\"*.rst\""
    "--doctest-modules"
  ];

  pythonImportsCheck = [
    "colour"
  ];

  meta = with lib; {
    description = "Converts and manipulates common color representation (RGB, HSV, web, ...)";
    homepage = "https://github.com/vaab/colour";
    license = licenses.bsd2;
  };
}
