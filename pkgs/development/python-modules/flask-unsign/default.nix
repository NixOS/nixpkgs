{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  itsdangerous,
  markupsafe,
  pytestCheckHook,
  requests,
  setuptools,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "flask-unsign";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Paradoxis";
    repo = "Flask-Unsign";
    tag = "v${version}";
    hash = "sha256-/WK3g6Ef3mSKeT3aaSAh5J8estUN4sNmM9Tq9An/18A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    itsdangerous
    markupsafe
    requests
    werkzeug
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flask_unsign" ];

  pytestFlagsArray = [ "tests/flask_unsign.py" ];

  meta = {
    description = "Command line tool to fetch, decode, brute-force and craft session cookies of Flask applications";
    homepage = "https://github.com/Paradoxis/Flask-Unsign";
    changelog = "https://github.com/Paradoxis/Flask-Unsign/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "flask-unsign";
  };
}
