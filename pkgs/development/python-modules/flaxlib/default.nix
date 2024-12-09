{
  lib,
  buildPythonPackage,
  flax,
  tomlq,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flaxlib";
  version = "0.0.1-a1";
  pyproject = true;

  inherit (flax) src;

  sourceRoot = "${src.name}/flaxlib";

  postPatch = ''
    expected_version="$version"
    actual_version=$(${lib.getExe tomlq} --file Cargo.toml "package.version")

    if [ "$actual_version" != "$expected_version" ]; then
      echo -e "\n\tERROR:"
      echo -e "\tThe version of the flaxlib python package ($expected_version) does not match the one in its Cargo.toml file ($actual_version)"
      echo -e "\tPlease update the version attribute of the nix python3Packages.flaxlib package."
      exit 1
    fi
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-RPbMHnRdJaWKLU9Rkz39lmfibO20dnfZmLZqehHM3w4=";
  };

  nativeBuildInputs = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  pythonImportsCheck = [ "flaxlib" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # This package does not have tests (yet ?)
  doCheck = false;

  passthru = {
    inherit (flax) updateScript;
  };

  meta = {
    description = "Rust library used internally by flax";
    homepage = "https://github.com/google/flax/tree/main/flaxlib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
