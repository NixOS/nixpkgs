{
  lib,
  betamax,
  blinker,
  buildPythonPackage,
  coverage,
  fetchFromGitHub,
  flask,
  flask-caching,
  flask-login,
  flask-sqlalchemy,
  flit,
  freezegun,
  oauthlib,
  pallets-sphinx-themes,
  pillow,
  pytest,
  pytest-mock,
  pytestCheckHook,
  requests,
  requests-oauthlib,
  responses,
  sphinx,
  sphinxcontrib-seqdiag,
  sphinxcontrib-spelling,
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

  build-system = [ flit ];

  dependencies = [
    flask
    oauthlib
    requests
    requests-oauthlib
    urlobject
    werkzeug
  ];

  optional-dependencies = {
    docs = [
      betamax
      pallets-sphinx-themes
      pillow
      sphinx
      sphinxcontrib-seqdiag
      sphinxcontrib-spelling
      sqlalchemy
    ];

    signals = [ blinker ];

    sqla = [ sqlalchemy ];

    test = [
      betamax
      coverage
      flask-caching
      flask-login
      flask-sqlalchemy
      freezegun
      oauthlib
      pytest
      pytest-mock
      responses
      sqlalchemy
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "flask_dance" ];

  meta = {
    description = "Doing the OAuth dance with style using Flask, requests, and oauthlib";
    homepage = "https://github.com/singingwolfboy/flask-dance";
    changelog = "https://github.com/singingwolfboy/flask-dance/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
