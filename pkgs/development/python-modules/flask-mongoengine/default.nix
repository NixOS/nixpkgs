{ lib
, buildPythonPackage
, email-validator
, fetchFromGitHub
, flask
, flask-wtf
, markupsafe
, mongoengine
, pythonOlder
, setuptools
, setuptools-scm
, typing-extensions
, wtforms
}:

buildPythonPackage rec {
  pname = "flask-mongoengine";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-YqEtW02VvEeUsLIHLz6+V6juMtWPEIk2tLoKTUdY6YE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    email-validator
    flask
    flask-wtf
    mongoengine
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    wtf = [
      flask-wtf
      wtforms
    ] ++ wtforms.optional-dependencies.email;
    # toolbar = [
    #   flask-debugtoolbar
    # ];
    legacy = [
      markupsafe
    ];
  };

  # Tests require working mongodb connection
  doCheck = false;

  pythonImportsCheck = [
    "flask_mongoengine"
  ];

  meta = with lib; {
    description = "Flask extension that provides integration with MongoEngine and WTF model forms";
    homepage = "https://github.com/mongoengine/flask-mongoengine";
    changelog = "https://github.com/MongoEngine/flask-mongoengine/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
