{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.1.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0189168749ddea8601afd648146c502533f93ae33840eb76cd71f694742623cd";
  };

  postPatch = ''
    # fixes build on non-x86_64 architectures
    rm frozendict/src/3_9/cpython_src/Include/pyconfig.h
  '';

  pythonImportsCheck = [
    "frozendict"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -r frozendict
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  disabledTests = [
    # TypeError: unsupported operand type(s) for |=: 'frozendict.frozendict' and 'dict'
    "test_union"
    # non-standard assertions
    "test_repr"
    "test_format"
    "test_str"
  ];

  disabledTestPaths = [
    # unpackaged test dependency: coold
    "test/test_coold.py"
    "test/test_coold_subclass.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/slezica/python-frozendict";
    description = "An immutable dictionary";
    license = licenses.mit;
  };
}
