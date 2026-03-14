{
  lib,
  betamax,
  blinker,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  flask-caching,
  flask-login,
  flask-sqlalchemy,
  flit-core,
  freezegun,
  oauthlib,
  pytest-mock,
  pytestCheckHook,
  requests,
  requests-oauthlib,
  responses,
  sqlalchemy,
  urlobject,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "flask-dance";
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "singingwolfboy";
    repo = "flask-dance";
    tag = "v${version}";
    hash = "sha256-rKHC0G5S7l52QSrbbweMii68AZuBAgf6tYsJdPKIeUk=";
  };

  build-system = [ flit-core ];

  dependencies = [
    flask
    oauthlib
    requests
    requests-oauthlib
    urlobject
    werkzeug
  ];

  optional-dependencies = {
    signals = [ blinker ];
    sqla = [ sqlalchemy ];
  };

  nativeCheckInputs = [
    betamax
    flask-caching
    flask-login
    flask-sqlalchemy
    freezegun
    pytest-mock
    pytestCheckHook
    responses
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "flask_dance" ];

  meta = {
    description = "Doing the OAuth dance with style using Flask, requests, and oauthlib";
    homepage = "https://github.com/singingwolfboy/flask-dance";
    changelog = "https://github.com/singingwolfboy/flask-dance/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
