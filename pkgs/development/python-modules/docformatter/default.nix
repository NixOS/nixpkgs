{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, untokenize
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "docformatter";
  version = "1.5.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nccWWdO4U8MBjNey7DTV0FQ3ASjhK3nuZVSYyzOcxxE=";
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
