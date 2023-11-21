{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
, openssl
, perl
}:

buildPythonPackage rec {
  pname = "clvm_rs";
  version = "0.3.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_rs";
    rev = version;
    hash = "sha256-DJviuIBJg+MF0NvmdeWK31nV+q4UZCRdmdbEAJqwXXg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-bgXUSm3M8J7E2ohPjPIimHJvz1ivWrsliKZlgchOdhQ=";
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
