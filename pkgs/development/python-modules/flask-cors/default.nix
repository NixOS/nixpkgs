{ lib
, fetchFromGitHub
, buildPythonPackage
, flask
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Flask-Cors";
  version = "4.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "corydolphin";
    repo = "flask-cors";
    rev = "refs/tags/v${version}";
    hash = "sha256-dRrgSJ5CADM0/VNSMYPPk3CALmyMH18OofrONVEKNMU=";
  };

  propagatedBuildInputs = [
    flask
  ];

  nativeCheckInputs = [
    pytestCheckHook
    packaging
  ];

  meta = with lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = "https://github.com/corydolphin/flask-cors";
    changelog = "https://github.com/corydolphin/flask-cors/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickcao ];
  };
}
