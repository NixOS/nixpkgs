{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  future,
  matplotlib,
  numpy,
  pytestCheckHook,
  pytest-mock,
  pythonOlder,
  scipy,
  ezyrb,
}:

let
  self = buildPythonPackage rec {
    pname = "pydmd";
    version = "2025.01.01";
    pyproject = true;

    disabled = pythonOlder "3.6";

    src = fetchFromGitHub {
      owner = "PyDMD";
      repo = "PyDMD";
      tag = version;
      hash = "sha256-edjBr0LsfyBEi4YZiTY0GegqgESWgSFennZOi2YFhC4=";
    };

    build-system = [ setuptools ];

    propagatedBuildInputs = [
      future
      matplotlib
      numpy
      scipy
      ezyrb
    ];

    nativeCheckInputs = [
      pytestCheckHook
      pytest-mock
    ];

    pytestFlagsArray = [ "tests/test_dmdbase.py" ];

    pythonImportsCheck = [ "pydmd" ];

    passthru.tests = self.overrideAttrs (old: {
      pytestFlagsArray = [ ];
    });

    meta = with lib; {
      description = "Python Dynamic Mode Decomposition";
      homepage = "https://pydmd.github.io/PyDMD/";
      changelog = "https://github.com/PyDMD/PyDMD/releases/tag/${src.tag}";
      license = licenses.mit;
      maintainers = with maintainers; [ yl3dy ];
    };
  };
in
self
