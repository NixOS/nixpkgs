{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, cython

# optional
, numpy

# tests
, hypothesis
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ndindex";
<<<<<<< HEAD
  version = "1.7";
=======
  version = "1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "ndindex";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-JP0cEuxXfPTWc1EIUtMsy5Hx6eIo9vDzD0IUXm1lFME=";
=======
    hash = "sha256-QLWGgbF5nNTa1SsSkupo+fAs9K7eTexTK9n9yDLVgrQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=ndindex/ --cov-report=term-missing --flakes" ""
  '';

  passthru.optional-dependencies.arrays = [
    numpy
  ];

  pythonImportsCheck = [
    "ndindex"
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-cov # uses cov markers
    pytestCheckHook
  ] ++ passthru.optional-dependencies.arrays;

  pytestFlagsArray = [
    # pytest.PytestRemovedIn8Warning: Passing None has been deprecated.
    "--deselect=ndindex/tests/test_ndindex.py::test_ndindex_invalid"
  ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/Quansight-Labs/ndindex";
    changelog = "https://github.com/Quansight-Labs/ndindex/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
