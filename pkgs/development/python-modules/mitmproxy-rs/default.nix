{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  libiconv,
  mitmproxy,
  mitmproxy-macos,
}:

buildPythonPackage rec {
  pname = "mitmproxy-rs";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    rev = version;
    hash = "sha256-zBlt83mtJOsVqskDAkpk50yZHxJO6B8QP7iv8L1YPWA=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    outputHashes = {
      "smoltcp-0.11.0" = "sha256-KC9nTKd2gfZ1ICjrkLK//M2bbqYlfcCK18gBdN0RqWQ=";
    };
    lockFile = ./Cargo.lock;
  };

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
    inherit (mitmproxy.meta) maintainers;
  };
}
