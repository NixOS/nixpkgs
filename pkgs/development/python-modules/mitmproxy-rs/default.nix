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
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    rev = version;
    hash = "sha256-rnM2MNJ9ZVmwFjhXU8kPEQjpqNIzVZ3bVtm43WvGj5E=";
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
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${src.rev}/CHANGELOG.md#${lib.replaceStrings ["."] [""] version}";
    license = licenses.mit;
    inherit (mitmproxy.meta) maintainers;
  };
}
