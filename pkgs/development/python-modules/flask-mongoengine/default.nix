{
  lib,
  buildPythonPackage,
  email-validator,
  fetchFromGitHub,
  flask,
  flask-wtf,
  markupsafe,
  mongoengine,
  setuptools,
  setuptools-scm,
  wtforms,
}:

buildPythonPackage rec {
  pname = "flask-mongoengine";
  version = "1.0.0-unstable-2022-08-16";
  pyproject = true;

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
  ];

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

  meta = {
    description = "Flask extension that provides integration with MongoEngine and WTF model forms";
    homepage = "https://github.com/mongoengine/flask-mongoengine";
    changelog = "https://github.com/MongoEngine/flask-mongoengine/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
