{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, poetry-core

# docs
, furo
, sphinxHook

# runtime
, babel
, flask
, jinja2
, pytz

# tests
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-babel";
  version = "3.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-babel";
    repo = "flask-babel";
    rev = "refs/tags/v${version}";
    hash = "sha256-c3QKAnyMe1THHuJ3uB2d0jMMo1SYGRAB9mBpIJSAHw0=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    furo
    poetry-core
    sphinxHook
  ];

  propagatedBuildInputs = [
    babel
    flask
    jinja2
    pytz
  ];

  pythonImportsCheck = [
    "flask_babel"
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/python-babel/flask-babel/releases/tag/v${version}";
    description = "Adds i18n/l10n support to Flask applications";
    longDescription = ''
      Implements i18n and l10n support for Flask.
      This is based on the Python babel module as well as pytz both of which are
      installed automatically for you if you install this library.
    '';
    license = licenses.bsd2;
    maintainers = teams.sage.members;
    homepage = "https://github.com/python-babel/flask-babel";
  };
}
