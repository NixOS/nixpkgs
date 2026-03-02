{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "duct-py";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "oconnor663";
    repo = "duct.py";
    tag = version;
    hash = "sha256-i811nQB8CVJPYPR0Jdzpk64EXxrTMDIBpdDoUs9Xu/k=";
  };

  pythonImportsCheck = [ "duct" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # This test completely empties the environment then tries to run a Python command.
    # The test then fails because it can't find the `python` executable. It's unclear
    # how this test even passes _outside_ of Nix.
    "test_full_env"
  ];

  meta = {
    description = "Python library for running child processes";
    homepage = "https://github.com/oconnor663/duct.py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zmitchell ];
  };
}
