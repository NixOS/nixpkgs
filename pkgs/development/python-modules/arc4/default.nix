{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "arc4";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "manicmaniac";
    repo = "arc4";
    rev = version;
    hash = "sha256-DlZIygf5v3ZNY2XFmrKOA15ccMo3Rv0kf6hZJ0CskeQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "arc4" ];

  meta = {
    description = "ARCFOUR (RC4) cipher implementation";
    homepage = "https://github.com/manicmaniac/arc4";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
