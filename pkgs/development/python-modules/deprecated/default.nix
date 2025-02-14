{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonAtLeast,
  setuptools,
  wrapt,
  pytestCheckHook,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "deprecated";
  version = "1.2.15";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "tantale";
    repo = "deprecated";
    tag = "v${version}";
    hash = "sha256-slMPL2L0TZ7L19nfHMOM4jQlkJ7HIyyDPlfC9yhhd98=";
  };

  patches = [
    # https://github.com/laurent-laporte-pro/deprecated/pull/79
    ./sphinx8-compat.patch
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [ sphinxHook ];

  propagatedBuildInputs = [ wrapt ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # assertion text mismatch
    "test_classic_deprecated_class_method__warns"
    "test_sphinx_deprecated_class_method__warns"
  ];

  pythonImportsCheck = [ "deprecated" ];

  meta = with lib; {
    homepage = "https://github.com/tantale/deprecated";
    description = "Python @deprecated decorator to deprecate old python classes, functions or methods";
    license = licenses.mit;
    maintainers = with maintainers; [ tilpner ];
  };
}
