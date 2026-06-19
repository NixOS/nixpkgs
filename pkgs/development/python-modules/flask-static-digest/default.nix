{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  wheel,

  # dependencies
  flask,

  # optional-dependencies
  brotli,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-static-digest";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nickjj";
    repo = "flask-static-digest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A+NELUCjYTkUYbL0TIPvgGcJ49YRgoBn/eJRxi/yLyc=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ flask ];

  optional-dependencies.brotli = [ brotli ];

  # Upstream does not provide tests.
  doCheck = false;

  pythonImportsCheck = [ "flask_static_digest" ];

  meta = {
    description = "Flask extension for md5 tagging and compressing static files";
    homepage = "https://github.com/nickjj/flask-static-digest";
    changelog = "https://github.com/nickjj/flask-static-digest/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mert-kurttutan ];
  };
})
