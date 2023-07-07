{ lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
}:

buildPythonPackage rec {
  pname = "clvm-tools-rs";
  version = "0.1.30";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_tools_rs";
    rev = version;
    hash = "sha256-7eGOJgcZcSGmvLJc5BVfWarcu9kQb/uEcnG70JWXDSw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-46WEmp1FT6biM9A2M7z5onb45XhWjePKb6NSwLjuemc=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImportsCheck = [ "clvm_tools_rs" ];

  meta = with lib; {
    homepage = "https://chialisp.com/";
    description = "Rust port of clvm_tools";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
