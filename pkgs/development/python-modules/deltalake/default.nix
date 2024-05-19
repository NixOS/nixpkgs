{ lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,

  # Python dependencies
  pyarrow,
  pyarrow-hotfix,

  # Native dependencies
  openssl,
}:
buildPythonPackage rec {
  pname = "deltalake";
  version = "0.17.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "delta-io";
    repo = "delta-rs";
    rev = "python-v${version}";
    hash = "sha256-e+XbsM3CH++ITPmkMNyaf71Noozyx94N9a4P1q3QgAw=";
  };

  # Since delta-rs does not provide their own Cargo.lock we need to provide it
  # ourselves.
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  buildAndTestSubdir = "python";

  env = {
    # needed for openssl-sys
    OPENSSL_NO_VENDOR = 1;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  dependencies = [ pyarrow pyarrow-hotfix ];

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    bindgenHook
  ];

  buildInputs = [ openssl ];

  pythonImportsCheck = [ "deltalake" ];

  meta = {
    description = "Native Delta Lake Python binding based on delta-rs with Pandas integration";
    homepage = "https://delta-io.github.io/delta-rs/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ coastalwhite ];
  };
}
