{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "parameterizedtestcase";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ccc1d15d7e7ef153619a6a9cd45b170268cf82c67fdd336794c75139aae127e";
  };

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m parameterizedtestcase.tests
    runHook postCheck
  '';

  doCheck = isPy27;

  meta = with lib; {
    description = "Parameterized tests for Python's unittest module";
    homepage = "https://github.com/msabramo/python_unittest_parameterized_test_case";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    broken = python.isPy3k; # uses use_2to3
  };
}
