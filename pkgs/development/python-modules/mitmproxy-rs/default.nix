{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, darwin
}:

buildPythonPackage rec {
  pname = "mitmproxy-rs";
  version = "0.3.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    rev = version;
    hash = "sha256-V6LUr1jJiTo0+53jipkTyzG5JSw6uHaS6ziyBaFbETw=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "internet-packet-0.1.0" = "sha256-VtEuCE1sulBIFVymh7YW7VHCuIBjtb6tHoPz2tjxX+Q=";
    };
  };

  buildAndTestSubdir = "mitmproxy-rs";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  pythonImportsCheck = [ "mitmproxy_rs" ];

  meta = with lib; {
    description = "The Rust bits in mitmproxy";
    homepage = " https://github.com/mitmproxy/mitmproxy_rs";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
