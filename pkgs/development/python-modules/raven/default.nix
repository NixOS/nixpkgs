{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  blinker,
  flask,
}:

buildPythonPackage rec {
  pname = "raven";
  version = "6.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "raven-python";
    rev = version;
    hash = "sha256-iG+rpeJPB8OpYMrgIUEQzmPq6noVHzgLp+54hmijqZs=";
  };

  # requires outdated dependencies which have no official support for python 3.4
  doCheck = false;

  pythonImportsCheck = [ "raven" ];

  optional-dependencies = {
    flask = [
      blinker
      flask
    ];
  };

  meta = {
    description = "Legacy Python client for Sentry (getsentry.com) — replaced by sentry-python";
    mainProgram = "raven";
    homepage = "https://github.com/getsentry/raven-python";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
