{
  lib,
  aiosmtpd,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  mkdocs-material-extensions,
  flask,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "flask-mailman";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "waynerv";
    repo = "flask-mailman";
    tag = "v${version}";
    hash = "sha256-0kD3rxFDJ7FcmBLVju75z1nf6U/7XfjiLD/oM/VP4jQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    flask
    mkdocs-material-extensions
  ];

  nativeCheckInputs = [
    aiosmtpd
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flask_mailman" ];

  meta = with lib; {
    changelog = "https://github.com/waynerv/flask-mailman/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://github.com/waynerv/flask-mailman";
    description = "Flask extension providing simple email sending capabilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
