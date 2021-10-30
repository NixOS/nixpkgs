{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pur";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "alanhamlett";
    repo = "pip-update-requirements";
    rev = version;
    sha256 = "sha256-a2wViLJW+UXgHcURxr4irFVkH8STH84AVcwQIkvH+Fg=";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pur" ];

  meta = with lib; {
    description = "Python library for update and track the requirements";
    homepage = "https://github.com/alanhamlett/pip-update-requirements";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
