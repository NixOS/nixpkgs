{
  stdenv,
  lib,
  buildPythonPackage,
  cargo,
  fetchPypi,
  pytestCheckHook,
  rustc,
  rustPlatform,
  libiconv,
}:

buildPythonPackage rec {
  pname = "rpds-py";
  version = "0.30.0";
  pyproject = true;

  src = fetchPypi {
    pname = "rpds_py";
    inherit version;
    hash = "sha256-3Y/3z5ABSvDA94fuo0eU6/ZBUkLuHW+pHqunJcxEHoQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-2m2DW1rknZR+UztgUcRaQk4gY19eXmT089U2YlV16d8=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rpds" ];

  meta = {
    changelog = "https://github.com/crate-py/rpds/releases/tag/v${version}";
    description = "Python bindings to Rust's persistent data structures";
    homepage = "https://github.com/crate-py/rpds";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
