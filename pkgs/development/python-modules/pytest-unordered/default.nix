{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-unordered";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "utapyngo";
    repo = pname;
    rev = "972012a984b1e9fb3e98f9e8fe9e2ada16ad8110";
    hash = "sha256-mCcR6WZb2+V5n0PwgsjvnChWnANkIyQ0YtqwTKBYtaA=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_unordered" ];

  meta = with lib; {
    description = "Test equality of unordered collections in pytest";
    homepage = "https://github.com/utapyngo/pytest-unordered";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
