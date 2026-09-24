{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # build-system
  cargo,
  rustc,
}:

buildPythonPackage rec {
  pname = "py-rust-stemmers";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "py-rust-stemmers";
    tag = "v${version}";
    hash = "sha256-WpTbS8XoOKhyyt1/YGagulopFKiqNI0ETkhjpiX0TL8=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonImportsCheck = [ "py_rust_stemmers" ];

  meta = {
    description = "High-performance Python wrapper around the rust-stemmers library, utilizing the Snowball stemming algorithm";
    homepage = "https://github.com/qdrant/py-rust-stemmers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
