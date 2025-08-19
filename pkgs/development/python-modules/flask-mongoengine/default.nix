{
  lib,
  buildPythonPackage,
  email-validator,
  fetchFromGitHub,
  flask,
  flask-wtf,
  markupsafe,
  mongoengine,
  pythonOlder,
  setuptools,
  setuptools-scm,
  typing-extensions,
  wtforms,
}:

buildPythonPackage rec {
  pname = "flask-mongoengine";
  version = "1.0.0-unstable-2022-08-16";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = "flask-mongoengine";
    rev = "d4526139cb1e2e94111ab7de96bb629d574c1690";
    hash = "sha256-oMQU9Z8boc0q+0KzIQAZ8qSyxiITDY0M9FCg75S9MEY=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "1.0.0";

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    email-validator
    flask
    flask-wtf
    mongoengine
  ]
  ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  optional-dependencies = {
    wtf = [
      flask-wtf
      wtforms
    ]
    ++ wtforms.optional-dependencies.email;
    # toolbar = [
    #   flask-debugtoolbar
    # ];
    legacy = [ markupsafe ];
  };

  # Tests require working mongodb connection
  doCheck = false;

  pythonImportsCheck = [ "flask_mongoengine" ];

  meta = with lib; {
    description = "Flask extension that provides integration with MongoEngine and WTF model forms";
    homepage = "https://github.com/mongoengine/flask-mongoengine";
    changelog = "https://github.com/MongoEngine/flask-mongoengine/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
