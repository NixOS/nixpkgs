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
  version = "0.1.10";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_rs";
    rev = version;
    sha256 = "sha256-ersQ5jz2dW9paWFqgkwmwLZkkqKxhT0lTRt78cRRoSc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-tJWTHTSg9HLd/7m7P3ZJw+QRgkIvt/SvtjFI0oKctxU=";
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
