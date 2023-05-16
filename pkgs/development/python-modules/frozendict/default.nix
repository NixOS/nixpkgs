{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "frozendict";
<<<<<<< HEAD
  version = "2.3.8";
=======
  version = "2.3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Marco-Sulla";
    repo = "python-frozendict";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-4a0DvZOzNJqpop7wi+FagUR+8oaekz4EDNIYdUaAWC8=";
=======
    hash = "sha256-IlKhqQvNaYz4+U8UJ/fGUNNTC3RjyGKCJUzJ6J431Vw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # https://github.com/Marco-Sulla/python-frozendict/pull/69
    substituteInPlace setup.py \
      --replace 'if impl == "PyPy":' 'if impl == "PyPy" or not src_path.exists():'
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "frozendict"
  ];

  preCheck = ''
    pushd test
  '';

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/Marco-Sulla/python-frozendict/issues/68
    "test_c_extension"
  ];

  meta = with lib; {
    description = "Module for immutable dictionary";
    homepage = "https://github.com/Marco-Sulla/python-frozendict";
    changelog = "https://github.com/Marco-Sulla/python-frozendict/releases/tag/v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ ];
  };
}
