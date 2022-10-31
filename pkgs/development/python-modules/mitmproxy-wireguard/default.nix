{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, rustPlatform
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "mitmproxy-wireguard";
  version = "0.1.15";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "decathorpe";
    repo = "mitmproxy_wireguard";
    rev = "refs/tags/${version}";
    hash = "sha256-31S955juthagoFsthVTf3Vjx2YCKn43HKJ6mjrA8lfw=";
  };

  nativeBuildInputs = [
    setuptools-rust
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-e2P3vfiaTOUf28Lexv2SDFaiGE55G8EkDKSYb8b7vLM=";
  };

  # Module has no tests, only a test client
  doCheck = false;

  pythonImportsCheck = [
    "mitmproxy_wireguard"
  ];

  meta = with lib; {
    description = "WireGuard frontend for mitmproxy";
    homepage = "https://github.com/decathorpe/mitmproxy_wireguard";
    changelog = "https://github.com/decathorpe/mitmproxy_wireguard/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
