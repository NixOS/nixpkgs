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
  version = "0.1.20";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "decathorpe";
    repo = "mitmproxy_wireguard";
    rev = "refs/tags/${version}";
    hash = "sha256-Oq3jF4XeT58rad0MWmqucZZHVAshhA8PViQ+2Q9Shgc=";
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
    hash = "sha256-HIChSAVztTmftwLhCWeLX2afqXAIHp3pmVWeW4yFZ+0=";
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
