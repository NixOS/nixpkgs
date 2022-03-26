{ lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
, openssl
, perl
, pkgs
}:

let
  # clvm-rs does not work with maturin 0.12
  # https://github.com/Chia-Network/clvm_rs/commit/32fba40178a5440a1306623f47d8b0684ae2339a#diff-50c86b7ed8ac2cf95bd48334961bf0530cdc77b5a56f852c5c61b89d735fd711
  maturin_0_11 = with pkgs; rustPlatform.buildRustPackage rec {
    pname = "maturin";
    version = "0.11.5";
    src = fetchFromGitHub {
      owner = "PyO3";
      repo = "maturin";
      rev = "v${version}";
      hash = "sha256-hwc6WObcJa6EXf+9PRByUtiupMMYuXThA8i/K4rl0MA=";
    };
    cargoHash = "sha256-qGCEfKpQwAC57LKonFnUEgLW4Cc7HFJgSyUOzHkKN9c=";


    nativeBuildInputs = [ pkg-config ];

    buildInputs = lib.optionals stdenv.isLinux [ dbus ]
      ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security libiconv ];

    # Requires network access, fails in sandbox.
    doCheck = false;
  };
in

buildPythonPackage rec {
  pname = "clvm_rs";
  version = "0.1.19";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_rs";
    rev = version;
    sha256 = "sha256-mCKY/PqNOUTaRsFDxQBvbTD6wC4qzP0uv5FldYkwl6c=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-TmrR8EeySsGWXohMdo3dCX4oT3l9uLVv5TUeRxCBQeE=";
  };

  format = "pyproject";

  buildAndTestSubdir = "wheel";

  nativeBuildInputs = [
    perl # used by openssl-sys to configure
    maturin_0_11
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
