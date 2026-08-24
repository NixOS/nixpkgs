{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GTG7Vw0koeyDIkTlpRg8tRM0ESOJ9/3loLLRw3dCto0=";
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
    description = "Library for making pulses that can be leveraged with QCoDeS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evilmav ];
  };
}
