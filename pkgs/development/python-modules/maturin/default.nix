{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  setuptools-rust,
  cargo,
  rustc,
}:
buildPythonPackage rec {
  pname = "maturin";
  version = "1.9.6";
  format = "pyproject";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LCrjcUSBHTZVCYie1yILBZhIfxJ4wkQYKcOr9WzGMko=";
  };
  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    setuptools-rust
  ];
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-hNFbRtt/sVlEffu7RgXxC1NHzakP8miMyHIV/cf4sfM=";
  };
  pythonImportsCheck = [ "maturin" ];
  meta = with lib; {
    description = "Build and publish crates with pyo3, cffi and uniffi bindings as well as rust binaries as python packages";
    homepage = "https://github.com/pyo3/maturin";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ monk3yd ];
  };
}
