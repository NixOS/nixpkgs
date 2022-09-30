{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "arc4";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "manicmaniac";
    repo = pname;
    rev = version;
    hash = "sha256-z8zj46/xX/gXtWzlmnHuAsnK3xYCL4NM5/xpYcH+Qlo=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "arc4"
  ];

  meta = with lib; {
    description = "ARCFOUR (RC4) cipher implementation";
    homepage = "https://github.com/manicmaniac/arc4";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
