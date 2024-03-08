{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-migrate
, ldap3
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "automx2";
  version = "unstable-2023-08-23";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = pname;
    rev = "f3e3fc8e769c3799361001d51b7d9335a6a9d1a8";
    hash = "sha256-NkeazjjGDYUXfoydvEfww6e7SkSZ8rMRlML+oOaf374=";
  };

  propagatedBuildInputs = [
    flask
    flask-migrate
    ldap3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "automx2"
  ];

  meta = with lib; {
    description = "Email client configuration made easy";
    homepage = "https://rseichter.github.io/automx2/";
    changelog = "https://github.com/rseichter/automx2/blob/${version}/CHANGELOG";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ twey ];
  };
}
