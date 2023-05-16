{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, lark
, libcst
, parso
, pytestCheckHook
, pytest-xdist
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "hypothesmith";
<<<<<<< HEAD
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Uj2gTAY7hzko1sKO8WUGz2S/MXdwOYN+F+a73G4szNs=";
=======
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vc6EXsmE5uP+0h5l0ugrjrxt5cpeuTZJ39dgNMWQakY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./remove-black.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "lark-parser" "lark"

    substituteInPlace tox.ini \
      --replace "--cov=hypothesmith" "" \
      --replace "--cov-branch" "" \
      --replace "--cov-report=term-missing:skip-covered" "" \
      --replace "--cov-fail-under=100" ""
  '';

  propagatedBuildInputs = [ hypothesis lark libcst ];

  nativeCheckInputs = [ parso pytestCheckHook pytest-xdist ];

  pytestFlagsArray = [
    "-v"
  ];

  disabledTests = [
    # https://github.com/Zac-HD/hypothesmith/issues/21
    "test_source_code_from_libcst_node_type"
  ];

  disabledTestPaths = [
    # missing blib2to3
    "tests/test_syntactic.py"
  ];

  pythonImportsCheck = [ "hypothesmith" ];

  meta = with lib; {
    description = "Hypothesis strategies for generating Python programs, something like CSmith";
    homepage = "https://github.com/Zac-HD/hypothesmith";
<<<<<<< HEAD
    changelog = "https://github.com/Zac-HD/hypothesmith/blob/master/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
=======
    license = licenses.mpl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
