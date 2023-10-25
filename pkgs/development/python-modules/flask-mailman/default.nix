{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, mkdocs-material-extensions
, flask
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "flask-mailman";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "waynerv";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cfLtif+48M6fqOkBbi4PJRFpf9FRXCPesktFQky34eU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    flask
    mkdocs-material-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flask_mailman" ];

  meta = with lib; {
    homepage = "https://github.com/waynerv/flask-mailman";
    description = "Flask extension providing simple email sending capabilities.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
