{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "autocommand";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "Lucretiel";
    repo = "autocommand";
    rev = version;
    sha256 = "sha256-bjoVGfP57qhvPuHHcMP8JQddAaW4/fEyatElk1UEPZo=";
  };

  # fails with: SyntaxError: invalid syntax
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autocommand" ];

  meta = with lib; {
    description = " Autocommand turns a python function into a CLI program ";
    homepage = "https://github.com/Lucretiel/autocommand";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
