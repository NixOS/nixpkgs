{ lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
}:

buildPythonPackage rec {
  pname = "clvm-tools-rs";
  version = "0.1.19";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_tools_rs";
    rev = version;
    sha256 = "sha256-LQbFBZBLUAjyqIAWIn+N8tUrBMskRoKvMMg5gfTyVU8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-LcDWpMM+PUElsXO82H6QVOp338+NduC/j3pXQKSni3I=";
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
