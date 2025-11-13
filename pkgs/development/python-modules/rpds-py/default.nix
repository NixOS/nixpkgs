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
  version = "0.28.0";
  pyproject = true;

  src = fetchPypi {
    pname = "rpds_py";
    inherit version;
    hash = "sha256-q9TfIEhaCYPiyjNKIWJJthhtbjwWJ+EGZRlD29t5Guo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-mhFAV3KTVIUG/hU524cyeLv3sELv8wMtx820kPWeftE=";
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

  meta = with lib; {
    changelog = "https://github.com/crate-py/rpds/releases/tag/v${version}";
    description = "Python bindings to Rust's persistent data structures";
    homepage = "https://github.com/crate-py/rpds";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
