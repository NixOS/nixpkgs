{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  cvxopt,
  python,
  networkx,
  scipy,
  pythonOlder,
  stdenv,
}:

buildPythonPackage rec {
  pname = "picos";
  version = "2.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u9yaKeP34YW55+PyVy3wPR0p0jBmiLywvZzw2zWdd6g=";
  };

  # Needed only for the tests
  nativeCheckInputs = [ networkx ];

  dependencies = [
    numpy
    cvxopt
    scipy
  ];

  postPatch =
    lib.optionalString (pythonOlder "3.12") ''
      substituteInPlace picos/modeling/problem.py \
        --replace-fail "mappingproxy(OrderedDict({'x': <3×1 Real Variable: x>}))" "mappingproxy(OrderedDict([('x', <3×1 Real Variable: x>)]))"
    ''
    # TypeError: '<=' not supported between instances of 'ComplexAffineExpression' and 'float'
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
      rm tests/ptest_quantentr.py
    '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} test.py

    runHook postCheck
  '';

  meta = {
    description = "Python interface to conic optimization solvers";
    homepage = "https://gitlab.com/picos-api/picos";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tobiasBora ];
  };
}
