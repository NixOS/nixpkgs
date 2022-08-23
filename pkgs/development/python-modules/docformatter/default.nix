{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, untokenize
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "docformatter";
  version = "1.4";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "064e6d81f04ac96bc0d176cbaae953a0332482b22d3ad70d47c8a7f2732eef6f";
  };

  propagatedBuildInputs = [
    untokenize
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "docformatter" ];

  meta = {
    description = "Formats docstrings to follow PEP 257";
    homepage = "https://github.com/myint/docformatter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
