{ lib
, buildPythonPackage
, fetchFromGitHub
, defusedxml
, protobuf
, pythonRelaxDepsHook
, websocket-client
, pyogg
, zeroconf
, requests
, pycryptodomex
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "librespot";
  version = "0.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kokarare1212";
    repo = "librespot-python";
    rev = "v${version}";
    hash = "sha256-k9qVsxjRlUZ7vCBx00quiAR7S+YkfyoZiAKVnOOG4xM=";
  };

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

  pythonRelaxDeps = [
    "protobuf"
    "pyogg"
    "requests"
    "zeroconf"
  ];

  # Doesn't include any tests
  doCheck = false;

  pythonImportsCheck = [
    "librespot"
  ];

  meta = with lib; {
    description = "Open Source Spotify Client";
    homepage = "https://github.com/kokarare1212/librespot-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
