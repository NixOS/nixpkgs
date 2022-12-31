{ buildPythonPackage
, lib
, fetchFromGitHub
, pytestCheckHook
, rustPlatform
}:

buildPythonPackage rec {
  pname = "chia-rs";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "chia-network";
    repo = "chia_rs";
    rev = "refs/tags/${version}";
    sha256 = "sha256-WIt7yGceILzVhegluiSb7w3F9qQvI5DjulheGsJrcf8=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  preBuild = ''
    # avoid ENOENT in maturinBuildHook
    touch wheel/Cargo.lock
  '';

  checkInputs = [
    pytestCheckHook
  ];

  buildAndTestSubdir = "wheel";

  meta = with lib; {
    description = "Rust crate & wheel with consensus code";
    homepage = "https://github.com/Chia-Network/chia_rs/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
