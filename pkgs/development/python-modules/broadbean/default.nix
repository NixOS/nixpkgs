{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  versioningit,
  wheel,
  numpy,
  matplotlib,
  schema,
  hypothesis,
  pytestCheckHook,
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

  meta = with lib; {
    homepage = "https://qcodes.github.io/broadbean";
    description = "Library for making pulses that can be leveraged with QCoDeS";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}
