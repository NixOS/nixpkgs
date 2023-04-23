{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv
, darwin
, pytestCheckHook
, pythonOlder
, rustPlatform
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "mitmproxy-wireguard";
  version = "0.1.23";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "decathorpe";
    repo = "mitmproxy_wireguard";
    rev = "refs/tags/${version}";
    hash = "sha256-z9ucTBLLRXc1lcHA0r1wUleoP8X7yIlHrtdZdLD9qJk=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.libiconv
    darwin.apple_sdk.frameworks.Security
  ];

  nativeBuildInputs = [
    setuptools-rust
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-qgyAaUpyuWVYMxUA4Gg8inlUMlSLo++16+nVvmDMhTQ=";
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
