{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pdm-backend,

  # dependencies
  grpclib,
  python-dateutil,
  typing-extensions,

  # optional dependencies
  jinja2,
  ruff,
  betterproto-rust-codec,
}:

buildPythonPackage rec {
  pname = "betterproto-fw";
  version = "2.0.3";
  pyproject = true;

  # Not available on Github
  src = fetchPypi {
    pname = "betterproto_fw";
    inherit version;
    hash = "sha256-ut5GchUiTygHhC2hj+gSWKCoVnZrrV8KIKFHTFzba5M=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    grpclib
    python-dateutil
    typing-extensions
  ];

  optional-dependencies = {
    compiler = [
      jinja2
      ruff
    ];
    rust-codec = [
      betterproto-rust-codec
    ];
  };

  doCheck = false; # no tests supplied

  pythonImportsCheck = [
    "betterproto"
  ];

  meta = {
    description = "Fork of betterproto used in fireworks-ai";
    homepage = "https://pypi.org/project/betterproto-fw/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
