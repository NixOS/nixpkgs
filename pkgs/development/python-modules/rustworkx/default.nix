{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,

  # nativeBuildInputs
  cargo,
  rustc,

  # build-system
  setuptools,
  setuptools-rust,

  # dependencies
  numpy,

  # tests
  fixtures,
  networkx,
  pytestCheckHook,
  testtools,
}:

buildPythonPackage (finalAttrs: {
  pname = "rustworkx";
  version = "0.17.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "rustworkx";
    tag = finalAttrs.version;
    hash = "sha256-aBKGJwm9EmGwLOhIx6qTuDco5uNcnwUlZf3ztFzmIGs=";
  };

  # Otherwise, `rust-src` is required
  # https://github.com/Qiskit/rustworkx/pull/1447
  postPatch = ''
    rm -rf .cargo/config.toml
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-2jqyXk6xWpSGdpaVGu7YW9643MBYDfl3A6InFw/cCUM=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  build-system = [
    setuptools
    setuptools-rust
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    fixtures
    networkx
    pytestCheckHook
    testtools
  ];

  preCheck = ''
    rm -r rustworkx
  '';

  pythonImportsCheck = [ "rustworkx" ];

  meta = {
    description = "High performance Python graph library implemented in Rust";
    homepage = "https://github.com/Qiskit/rustworkx";
    changelog = "https://github.com/Qiskit/rustworkx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
})
