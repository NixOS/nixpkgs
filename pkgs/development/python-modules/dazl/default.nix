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
  version = "7.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IErym/Fd8G75NOa+xOyV87UNmEaB31XPvg8GWCSP7k8=";
  };

  patches = [
    # Merged, remove this next release
    (fetchpatch {
      url = "https://github.com/digital-asset/dazl-client/pull/428.patch";
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
