{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "python-clementine-remote";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jjmontesl";
    repo = "python-clementine-remote";
    tag = version;
    hash = "sha256-tPaxRBvt+tW4yV5Ap3YxMQxK3o7BJF3nP/wzBJeDgic=";
  };

  build-system = [ setuptools ];

  dependencies = [ protobuf ];

  # Project has no tests
  doCheck = false;

  env = {
    # https://github.com/jjmontesl/python-clementine-remote/pull/7
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

  pythonImportsCheck = [ "clementineremote" ];

  meta = {
    description = "Python library and CLI for the Clementine Music Player remote protocol";
    homepage = "https://github.com/jjmontesl/python-clementine-remote";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
