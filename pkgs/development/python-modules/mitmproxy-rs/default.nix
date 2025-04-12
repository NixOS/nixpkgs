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
  version = "0.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    rev = "v${version}";
    hash = "sha256-YRiaslXdpRGJfuZAHQ4zX+6DgH+IPkeyD8RA7TYgmBY=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "boringtun-0.6.0" = "sha256-fx2lY6q1ZdO5STvf7xnbVG64tn0BC4yWPFy4ICPJgEg=";
      "smoltcp-0.11.0" = "sha256-KC9nTKd2gfZ1ICjrkLK//M2bbqYlfcCK18gBdN0RqWQ=";
    };
  };

  buildAndTestSubdir = "mitmproxy-rs";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.AppKit
    libiconv
    mitmproxy-macos
  ];

  pythonImportsCheck = [ "mitmproxy_rs" ];

  meta = with lib; {
    description = "Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${src.rev}/CHANGELOG.md#${
      lib.replaceStrings [ "." ] [ "" ] version
    }";
    license = licenses.mit;
    inherit (mitmproxy.meta) maintainers;
  };
}
