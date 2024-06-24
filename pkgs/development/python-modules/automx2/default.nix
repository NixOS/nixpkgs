{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  flask-migrate,
  ldap3,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "automx2";
  version = "2024.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = "automx2";
    rev = version;
    hash = "sha256-s/kd9A/d3SPMZC9+B4DdcXVi77WLH/SBwXIdaKHUj34=";
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
