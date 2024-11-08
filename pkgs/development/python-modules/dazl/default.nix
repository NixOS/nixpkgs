{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

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
  version = "7.12.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fbemLaOh1PHBvQAmMy06JWgnOqdy/kLByAZh4U8ghxc=";
  };

  patches = [
    # Merged, remove this next release
    (fetchpatch {
      name = "428.patch"; # https://github.com/digital-asset/dazl-client/pull/428
      url = "https://github.com/digital-asset/dazl-client/commit/a68bad0471d22210f0abf31447a7732477de39d4.patch";
      sha256 = "sha256-Gx9W1XkvMPg8FAOAXijDF5QnMbntk5mR0q5+o5i2KAE=";
    })
  ];

  format = "pyproject";

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
