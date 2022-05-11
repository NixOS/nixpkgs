{ lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
, openssl
, maturin
, perl
}:

buildPythonPackage rec {
  pname = "clvm_tools_rs";
  version = "0.1.9";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_tools_rs";
    rev = version;
    sha256 = "sha256-nEsiuTRvzXQO2W7jCf3/XuEPfVRqlPBy513xG+E+0+8=";
  };

  patches = [
    ./bump-cargo-lock.patch
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";

    sha256 = "sha256-7wF4goWcPmfMufZi9D8tupHTHcNRAM472LIPylIB2z4=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    maturin
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
