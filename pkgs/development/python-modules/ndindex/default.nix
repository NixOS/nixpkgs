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
  version = "1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "ndindex";
    rev = "refs/tags/${version}";
    hash = "sha256-QLWGgbF5nNTa1SsSkupo+fAs9K7eTexTK9n9yDLVgrQ=";
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
