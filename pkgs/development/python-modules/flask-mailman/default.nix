{
  lib,
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
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "waynerv";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2ll5+D35dQN3r7gDpY1iSOuJBlqMorhjhFohPug8GK8=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    flask
    mkdocs-material-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flask_mailman" ];

  meta = with lib; {
    homepage = "https://github.com/waynerv/flask-mailman";
    description = "Flask extension providing simple email sending capabilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
