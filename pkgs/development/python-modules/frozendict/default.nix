{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.1.2";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Lrkvvo3eNwde0OXdPayIqFCgTM/GRtIPNBK3IiDduvI=";
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
