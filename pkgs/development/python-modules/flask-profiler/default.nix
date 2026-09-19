{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  flask-httpauth,
  simplejson,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-profiler";
  version = "1.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "muatik";
    repo = "flask-profiler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1am4OxzUTYdCkhT/Mm770ycTAIA9bZr65HgQ/SC1PMU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    flask
    flask-httpauth
    simplejson
  ];

  doCheck = false; # Tests require a running MongoDB or Redis instance

  pythonImportsCheck = [ "flask_profiler" ];

  meta = {
    description = "Profiler and dashboard for Flask applications";
    longDescription = ''
      Flask-profiler measures the performance of Flask endpoints and displays
      information like response times, success rates, and basic statistics via an API
      and web interface.
    '';
    homepage = "https://github.com/muatik/flask-profiler";
    changelog = "https://github.com/muatik/flask-profiler/blob/v${finalAttrs.version}/changelog.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
