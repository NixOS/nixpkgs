{ lib
, buildPythonPackage
, fetchPypi
, substituteAll
, graphviz
, python
, pytestCheckHook
, chardet
, pythonOlder
, pyparsing
}:

buildPythonPackage rec {
  pname = "pydot";
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d";
  };

  propagatedBuildInputs = [
    pyparsing
  ];

  checkInputs = [
    chardet
    pytestCheckHook
  ];

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      inherit graphviz;
    })
  ];

  postPatch = ''
    # test_graphviz_regression_tests also fails upstream: https://github.com/pydot/pydot/pull/198
    substituteInPlace test/pydot_unittest.py \
      --replace "test_graphviz_regression_tests" "no_test_graphviz_regression_tests" \
    # Patch path for pytestCheckHook
    substituteInPlace test/pydot_unittest.py \
      --replace "shapefile_dir = os.path.join(test_dir, 'from-past-to-future')" "shapefile_dir = 'test/from-past-to-future'" \
      --replace "path = os.path.join(test_dir, TESTS_DIR_1)" "path = os.path.join('test/', TESTS_DIR_1)"
  '';

  pytestFlagsArray = [
    "test/pydot_unittest.py"
  ];

  disabledTests = [
    "test_exception_msg"
    # Hash mismatch
    "test_my_regression_tests"
  ];

  pythonImportsCheck = [
    "pydot"
  ];

  meta = with lib; {
    description = "Allows to create both directed and non directed graphs from Python";
    homepage = "https://github.com/erocarrera/pydot";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
