{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "newrelic-telemetry-sdk";
  version = "0.9.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "newrelic";
    repo = "newrelic-telemetry-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0/6JqDbexo3olQHchzi+OMA8eFhP4ZqGsRJ67PCrA9c=";
  };

  postPatch = ''
    sed -i 's/strict=True,//g' src/newrelic_telemetry_sdk/client.py
    substituteInPlace pyproject.toml \
      --replace-fail 'setuptools_scm>=3.2,<9' 'setuptools_scm>=3.2'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "urllib3"
  ];

  dependencies = [
    urllib3
  ];

  doCheck = false; # Tests require network or use outdated doctests

  pythonImportsCheck = [ "newrelic_telemetry_sdk" ];

  meta = {
    description = "Telemetry SDK for New Relic";
    longDescription = ''
      The New Relic Telemetry SDK for Python provides the underlying
      primitives for sending telemetry data to New Relic using the
      Telemetry-SDK framework.
    '';
    homepage = "https://github.com/newrelic/newrelic-telemetry-sdk-python";
    changelog = "https://github.com/newrelic/newrelic-telemetry-sdk-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
