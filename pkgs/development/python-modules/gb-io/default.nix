{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  cargo,
  rustc,
  setuptools-rust,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gb-io";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "gb-io.py";
    tag = "v${version}";
    hash = "sha256-JWwH8ykMKSg1ztYodPzlnl8mpFXlQ9JFCf1LxqcNQvc=";
  };

  patches = [
    # Generate with cargo update pyo3 -Z unstable-options --breaking
    ./0001-Update-pyo3.patch
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    hash = "sha256-dX/rzL1rDjvHKoiaqtoX22t29TS9XR5aLW6fTabzLhc=";
  };

  build-system = [
    setuptools-rust
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gb_io" ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/althonos/gb-io.py";
    description = "Python interface to gb-io, a fast GenBank parser written in Rust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
