{ buildPythonPackage
, lib
, fetchFromGitHub
, pytestCheckHook
, rustPlatform
}:

buildPythonPackage rec {
  pname = "chia-rs";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "chia-network";
    repo = "chia_rs";
    rev = "refs/tags/${version}";
    hash = "sha256-MFVWdpfvmvGfWIuVdrigGucP52/dB4xCO4Pn1RvUJnM=";
  };

  patches = [
    # undo a hack from upstream that confuses our build hook
    ./fix-build.patch
  ];

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

  nativeCheckInputs = [
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
