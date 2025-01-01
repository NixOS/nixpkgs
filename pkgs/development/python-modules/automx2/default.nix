{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  flask-migrate,
  ldap3,
  pytestCheckHook,
  pythonOlder,
  pythonPackages,
  setuptools,
}:

buildPythonPackage rec {
  pname = "automx2";
  version = "2025.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = "automx2";
    tag = version;
    hash = "sha256-EG0S8Ie9U1nV96th7NdGsbAWXLVoqddHbGdHt/FUlqE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    flask
    flask-migrate
    ldap3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "automx2" ];

  meta = with lib; {
    description = "Email client configuration made easy";
    homepage = "https://rseichter.github.io/automx2/";
    changelog = "https://github.com/rseichter/automx2/blob/${version}/CHANGELOG";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ twey ];
  };
}
