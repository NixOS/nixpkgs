{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.3.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vJHGkjPrkWu268QJiLbYSXNXcCQO/JxgvkW0q5GcG94=";
  };

  pythonImportsCheck = [
    "frozendict"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    pushd test
  '';

  postCheck = ''
    popd
  '';

  meta = with lib; {
    homepage = "https://github.com/slezica/python-frozendict";
    description = "An immutable dictionary";
    license = licenses.mit;
  };
}
