{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  libiconv,
  mitmproxy-macos,
}:

buildPythonPackage rec {
  pname = "mitmproxy-rs";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    rev = version;
    hash = "sha256-nrm1T2yaGVmYsubwNJHPnPDC/A/jYiKVzwBKmuc9MD4=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  buildAndTestSubdir = "mitmproxy-rs";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    libiconv
    mitmproxy-macos
  ];

  pythonImportsCheck = [ "mitmproxy_rs" ];

  meta = with lib; {
    description = "Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
