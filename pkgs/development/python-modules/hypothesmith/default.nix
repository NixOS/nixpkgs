{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, lark
, libcst
, parso
, pytestCheckHook
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "hypothesmith";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vc6EXsmE5uP+0h5l0ugrjrxt5cpeuTZJ39dgNMWQakY=";
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

  checkInputs = [ parso pytestCheckHook pytest-xdist ];

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
    license = licenses.mpl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
