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
  version = "8.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2EXbfXNl/vNhOIKfBv18TKMPizab72LlNV7QhEf4aVs=";
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
