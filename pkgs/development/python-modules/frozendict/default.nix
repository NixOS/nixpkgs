{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.0.7";  # 2.0.6 breaks canonicaljson
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a68f609d1af67da80b45519fdcfca2d60249c0a8c96e68279c1b6ddd92128204";
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
