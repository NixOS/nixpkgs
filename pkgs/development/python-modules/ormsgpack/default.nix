{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "ormsgpack";
  version = "1.7.0";
  src = fetchFromGitHub {
    owner = "aviramha";
    repo = "ormsgpack";
    tag = version;
    hash = "sha256-YVkG5XyJ3eBgAwvLwJaCcL+584NhGVFMZ4/XbQ9UZWc=";
  };

  pyproject = true;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-8KSneEQ/yu/UocBs5ZiY17NMh/TGayrdQTKYqF1mmtY=";
  };

  # Enable nightly features for Rust compiler
  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "ormsgpack" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Msgpack serialization/deserialization library for Python, written in Rust using PyO3 and rust-msgpack";
    homepage = "https://github.com/aviramha/ormsgpack";
    license = with lib.licenses; [
      asl20
      mit
    ];
  };
}
