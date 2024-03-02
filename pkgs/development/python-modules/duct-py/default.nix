{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "duct-py";
  version = "0.6.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "oconnor663";
    repo = "duct.py";
    rev = version;
    hash = "sha256-4ja/SQ9R/SbKlf3NqKxLi+Fl/4JI0Fl/zG9EmTZjWZc=";
  };

  pythonImportsCheck = [ "duct" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # This test completely empties the environment then tries to run a Python command.
    # The test then fails because it can't find the `python` executable. It's unclear
    # how this test even passes _outside_ of Nix.
    "test_full_env"
  ];

  meta = with lib; {
    description = "A Python library for running child processes";
    homepage = "https://github.com/oconnor663/duct.py";
    license = licenses.mit;
    maintainers = with maintainers; [ zmitchell ];
  };
}
