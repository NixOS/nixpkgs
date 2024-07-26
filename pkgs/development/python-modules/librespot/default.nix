{ lib
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, protobuf
, pycryptodomex
, pyogg
, pytestCheckHook
, pythonRelaxDepsHook
, requests
, websocket-client
, zeroconf
}:

buildPythonPackage rec {
  pname = "librespot";
  version = "0.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kokarare1212";
    repo = "librespot-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-k9qVsxjRlUZ7vCBx00quiAR7S+YkfyoZiAKVnOOG4xM=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "librespot"
  ];

  meta = with lib; {
    description = "Open Source Spotify Client";
    homepage = "https://github.com/kokarare1212/librespot-python";
    changelog = "https://github.com/kokarare1212/librespot-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
