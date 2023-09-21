{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flask
, markdown
}:

buildPythonPackage rec {
  pname = "Flask-API";
  version = "3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "flask-api";
    repo = "flask-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-nHgeI5FLKkDp4uWO+0eaT4YSOMkeQ0wE3ffyJF+WzTM=";
  };

  propagatedBuildInputs = [
    flask
    markdown
  ];

  meta = with lib; {
    homepage = "https://github.com/flask-api/flask-api";
    changelog = "https://github.com/flask-api/flask-api/releases/tag/v${version}";
    description = "Browsable web APIs for Flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nickcao ];
  };
}
