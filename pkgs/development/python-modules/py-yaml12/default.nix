{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  cargo,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-yaml12";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "py_yaml12";
    hash = "sha256-57YUD61W1VKObVHHuP95vbJ2Mbc6mnwbxLVf2hvduu8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-/t8PXO5E9Avr7yQ8Ba/VvbQ/+2/6Vd+AeZRcqqTpOOw=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  meta = {
    description = "YAML 1.2 parser/formatter for Python, implemented in Rust for speed and correctness";
    homepage = "https://posit-dev.github.io/py-yaml12";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
})
