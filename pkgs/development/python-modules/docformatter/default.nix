{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, untokenize
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "docformatter";
  version = "1.5.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GSfsM6sPSLOIH0YJYFVTB3SigI62/ps51mA2iZ7GOEg=";
  };

  propagatedBuildInputs = [
    untokenize
  ];

  nativeCheckInputs = [
    mock
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
