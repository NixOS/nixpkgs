{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, setuptools
, versioningit
, wheel
, numpy
, matplotlib
, schema
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "broadbean";
  version = "0.14.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v+Ov6mlSnaJG98ooA9AhPGJflrFafKQoO5wi+PxcZVw=";
  };

  nativeBuildInputs = [
    setuptools
    versioningit
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    matplotlib
    schema
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # on a 200ms deadline
    "test_points"
  ];

  pythonImportsCheck = [ "broadbean" ];

  meta = {
    homepage = "https://qcodes.github.io/broadbean";
    description = "A library for making pulses that can be leveraged with QCoDeS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evilmav ];
  };
}
