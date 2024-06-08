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
    version = "1.0.0";
    pyproject = true;

    disabled = pythonOlder "3.6";

    src = fetchFromGitHub {
      owner = "PyDMD";
      repo = "PyDMD";
      rev = "refs/tags/v${version}";
      hash = "sha256-vprvq3sl/eNtu4cqg0A4XV96dzUt0nOtPmfwEv0h+PI=";
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
      changelog = "https://github.com/PyDMD/PyDMD/releases/tag/v${version}";
      license = licenses.mit;
      maintainers = with maintainers; [ yl3dy ];
      broken = stdenv.hostPlatform.isAarch64;
    };
  };
in
self
