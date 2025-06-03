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
  version = "1.2.18";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "tantale";
    repo = "deprecated";
    tag = "v${version}";
    hash = "sha256-gx5D1KAPELKfb2U93lvuztv3Ea3V+PshcfshIS6uwCo=";
  };

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
