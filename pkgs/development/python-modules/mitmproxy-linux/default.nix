{
  lib,
  buildPythonPackage,
  bpf-linker,
  fetchFromGitHub,
  rustPlatform,
  mitmproxy,
}:

buildPythonPackage rec {
  pname = "mitmproxy-linux";
  version = "0.11.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    tag = "v${version}";
    hash = "sha256-vC+Vsv7UWjkO+6lm7gAb91Ig04Y7r9gYQoz6R9xpxsA=";
  };

  postPatch = ''
    substituteInPlace mitmproxy-linux/build.rs \
      --replace-fail '"-Z",' "" \
      --replace-fail '"build-std=core",' ""

    substituteInPlace mitmproxy-linux-ebpf/.cargo/config.toml \
      --replace-fail 'build-std = ["core"]' ""
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-CFsefq1zQLIYjZcfoy3afYfP/0MlBoi9kVx7FVGEKr0=";
  };

  RUSTFLAGS = "-C target-feature=";
  RUSTC_BOOTSTRAP = 1;

  buildAndTestSubdir = "mitmproxy-linux";

  nativeBuildInputs = [
    bpf-linker
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  # repo has no python tests
  doCheck = false;

  pythonImportsCheck = [ "mitmproxy_linux" ];

  meta = {
    description = "Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs/tree/main/mitmproxy-linux";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${src.rev}/CHANGELOG.md#${
      lib.replaceStrings [ "." ] [ "" ] version
    }";
    license = lib.licenses.mit;
    inherit (mitmproxy.meta) maintainers;
  };
}
