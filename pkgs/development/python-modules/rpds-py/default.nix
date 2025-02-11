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
  version = "0.22.3";
  pyproject = true;

  src = fetchPypi {
    pname = "rpds_py";
    inherit version;
    hash = "sha256-4y/uirRdPC222hmlMjvDNiI3yLZTxwGUQUuJL9BqCA0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-2skrDC80g0EKvTEeBI4t4LD7ZXb6jp2Gw+owKFrkZzc=";
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
