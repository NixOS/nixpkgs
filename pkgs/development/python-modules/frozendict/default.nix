{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
, setuptoolsBuildHook
, python
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.0.6";  # 2.0.6 breaks canonicaljson
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f00de72805cf4c9e81b334f3f04809278b967d2fed84552313a0fcce511beb1";
  };

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
