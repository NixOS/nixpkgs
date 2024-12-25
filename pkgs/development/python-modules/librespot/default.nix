{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  protobuf,
  pycryptodomex,
  pyogg,
  pythonOlder,
  requests,
  setuptools,
  websocket-client,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "librespot";
  version = "0.0.9";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "kokarare1212";
    repo = "librespot-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-k9qVsxjRlUZ7vCBx00quiAR7S+YkfyoZiAKVnOOG4xM=";
  };

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    defusedxml
    protobuf
    pycryptodomex
    pyogg
    requests
    websocket-client
    zeroconf
  ];

  # Doesn't include any tests
  doCheck = false;

  pythonImportsCheck = [ "librespot" ];

  meta = with lib; {
    description = "Open Source Spotify Client";
    homepage = "https://github.com/kokarare1212/librespot-python";
    changelog = "https://github.com/kokarare1212/librespot-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
