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
  version = "1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "ndindex";
    rev = "refs/tags/${version}";
    hash = "sha256-JP0cEuxXfPTWc1EIUtMsy5Hx6eIo9vDzD0IUXm1lFME=";
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
