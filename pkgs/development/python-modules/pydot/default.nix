{ lib
, buildPythonPackage
, fetchPypi
, substituteAll
, graphviz
, python
, chardet
, pyparsing
}:

buildPythonPackage rec {
  pname = "pydot";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d49c9d4dd1913beec2a997f831543c8cbd53e535b1a739e921642fe416235f01";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      inherit graphviz;
    })
  ];

  postPatch = ''
    # test_graphviz_regression_tests also fails upstream: https://github.com/pydot/pydot/pull/198
    substituteInPlace test/pydot_unittest.py \
      --replace "test_graphviz_regression_tests" "no_test_graphviz_regression_tests"
  '';

  propagatedBuildInputs = [ pyparsing ];

  checkInputs = [ chardet ];

  checkPhase = ''
    cd test
    ${python.interpreter} pydot_unittest.py
  '';

  meta = {
    homepage = https://github.com/erocarrera/pydot;
    description = "Allows to easily create both directed and non directed graphs from Python";
    license = lib.licenses.mit;
  };
}
