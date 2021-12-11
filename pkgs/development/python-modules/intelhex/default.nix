{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "intelhex";
  version = "2.3.0";

  src = fetchFromGitHub {
     owner = "bialix";
     repo = "intelhex";
     rev = "2.3.0";
     sha256 = "13p7x4ygfgqn27q3c8lam7a0z09764iymgs7lcvjvxgq52nqwf9c";
  };

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "intelhex/test.py" ];

  pythonImportsCheck = [ "intelhex" ];

  meta = {
    homepage = "https://github.com/bialix/intelhex";
    description = "Python library for Intel HEX files manipulations";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pjones ];
  };
}
