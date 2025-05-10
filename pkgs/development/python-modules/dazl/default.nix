{
  lib,
  buildPythonPackage,
  fetchPypi,

  poetry-core,

  aiohttp,
  googleapis-common-protos,
  grpcio,
  protobuf,
  requests,
  semver,
  toposort,

  #, async_exit_stack
  #, dataclasses
  google-auth,
  oauthlib,
  prometheus-client,
  pygments,
  pyopenssl,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dazl";
  version = "8.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RwLjvVRAb7B1y0Hqd0lwYiqS8qrL8MhoH92RIMPWLqQ=";
  };

  pythonRelaxDeps = [
    "grpcio"
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    googleapis-common-protos
    grpcio
    protobuf
    requests
    semver
    toposort

    # optional

    #async-exit-stack
    #dataclasses
    google-auth
    oauthlib
    prometheus-client
    pygments
    pyopenssl
    typing-extensions
  ];

  meta = with lib; {
    description = "High-level Ledger API client for Daml ledgers";
    license = licenses.asl20;
  };
}
