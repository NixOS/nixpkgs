{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
, openssl
, perl
, pkgs
}:

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
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [ openssl ];

  pythonImportsCheck = [ "clvm_rs" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://chialisp.com/";
    description = "Rust implementation of clvm";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
