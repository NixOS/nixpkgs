{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  rustPlatform,
  pkg-config,

  # dependencies
  opentelemetry-api,
  pkgsHostTarget,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyqwest";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "curioswitch";
    repo = "pyqwest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9Cqp6+mWAg0CqVPySqRqqy1/NXDHjTtzcZnts1KHoi8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-JS/E56sIH8QvXsJu+eLXu7y4ZkFjn73SGgW04IZlX2w=";
  };

  # reqwest' http3 feature refuses to compile without these cfgs, which upstream
  # sets under `[build]`. Cargo ignores that section once cargoSetupHook has
  # appended its own `[target.<host>]` rustflags, and setting RUSTFLAGS instead
  # would shadow those. Flags from `cfg(...)` and `<triple>` sections are joined,
  # so retargeting upstream's section keeps both sets.
  postPatch = ''
    substituteInPlace .cargo/config.toml \
      --replace-fail '[build]' "[target.'cfg(all())']"
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    opentelemetry-api
  ];

  buildInputs = [
    pkgsHostTarget.aws-lc
    pkgsHostTarget.zstd
  ];

  pythonImportsCheck = [ "pyqwest" ];

  # The test suite spins up local HTTP/1, HTTP/2 and HTTP/3 servers through
  # `pyvoy`, which is not packaged in nixpkgs. Nothing it covers is
  # nixpkgs-specific: the packaging risk here is that the Rust extension fails
  # to build or load, which pythonImportsCheck catches.
  doCheck = false;

  meta = {
    description = "Modern, high-performance HTTP client for Python built on reqwest";
    homepage = "https://github.com/curioswitch/pyqwest";
    changelog = "https://github.com/curioswitch/pyqwest/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mishushakov ];
  };
})
