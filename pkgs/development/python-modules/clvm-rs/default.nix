{ lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
, openssl
, perl
}:

buildPythonPackage rec {
  pname = "clvm_rs";
  version = "0.1.15";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_rs";
    rev = version;
    sha256 = "sha256-4QFreQlRjKqGhPvuXU/pZpxMfF8LkIf6X7C3K2q77MI=";
  };

  patches = [
    # upstream forgot to refresh the lock file
    ./bump-cargo-lock.patch
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    sha256 = "sha256-jPNU+P6JgxTPL1GYUBE4VPU3p6cgL8u/+AIELr7r5Mk=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    perl # used by openssl-sys to configure
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [ openssl ];

  pythonImportsCheck = [ "clvm_rs" ];

  meta = with lib; {
    homepage = "https://chialisp.com/";
    description = "Rust implementation of clvm";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
