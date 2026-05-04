{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  click,
  flask,
  flask-debugtoolbar,
  itsdangerous,
  jinja2,
  markupsafe,
  mbdata,
  msgpack,
  redis,
  requests,
  sentry-sdk,
  sqlalchemy,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "brainzutils";
  version = "3.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "brainzutils-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NzBas9T+BxKTauSPSGsw6mOx8vjNEIeA7Rpf74efTro=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    flask
    flask-debugtoolbar
    itsdangerous
    jinja2
    markupsafe
    mbdata
    msgpack
    redis
    requests
    sentry-sdk
    sqlalchemy
    werkzeug
  ];

  pythonImportsCheck = [ "brainzutils" ];

  meta = {
    description = "Python utilities shared across MetaBrainz projects";
    homepage = "https://github.com/metabrainz/brainzutils-python";
    changelog = "https://github.com/metabrainz/brainzutils-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
