{
  lib,
  betamax,
  blinker,
  buildPythonPackage,
<<<<<<< HEAD
=======
  coverage,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  flask,
  flask-caching,
  flask-login,
  flask-sqlalchemy,
<<<<<<< HEAD
  flit-core,
  freezegun,
  oauthlib,
=======
  flit,
  freezegun,
  oauthlib,
  pallets-sphinx-themes,
  pillow,
  pytest,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytest-mock,
  pytestCheckHook,
  requests,
  requests-oauthlib,
  responses,
<<<<<<< HEAD
=======
  sphinx,
  sphinxcontrib-seqdiag,
  sphinxcontrib-spelling,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  build-system = [ flit-core ];
=======
  build-system = [ flit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dependencies = [
    flask
    oauthlib
    requests
    requests-oauthlib
    urlobject
    werkzeug
  ];

  optional-dependencies = {
<<<<<<< HEAD
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "flask_dance" ];

  meta = {
    description = "Doing the OAuth dance with style using Flask, requests, and oauthlib";
    homepage = "https://github.com/singingwolfboy/flask-dance";
    changelog = "https://github.com/singingwolfboy/flask-dance/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
