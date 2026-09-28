{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "newrelic";
  version = "12.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "newrelic";
    repo = "newrelic-python-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qxdMgMyG4t3md6eZ9NB6gXmYSk6OzvxijQAXbdJeSPg=";
  };

  postPatch = ''
    sed -i 's/"setuptools_scm>=3.2,<7"/"setuptools_scm"/g' setup.py
    sed -i '/scripts=\["scripts\/newrelic-admin"\],/d' setup.py
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "setuptools_scm"
  ];

  doCheck = false; # Tests require a real newrelic account and external services

  pythonImportsCheck = [ "newrelic" ];

  meta = {
    description = "Agent for the New Relic performance monitoring service";
    longDescription = ''
      The New Relic Python Agent enables instrumentation of Python applications.
    '';
    homepage = "https://github.com/newrelic/newrelic-python-agent";
    changelog = "https://docs.newrelic.com/docs/release-notes/agent-release-notes/python-release-notes/python-agent-${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
