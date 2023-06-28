{ lib
, buildPythonPackage
, fetchFromGitLab
, pkg-config
, rustPlatform
, cargo
, rustc
, bzip2
, nettle
, openssl
, pcsclite
, stdenv
, darwin
}:

buildPythonPackage rec {
  pname = "pysequoia";
  version = "0.1.14";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "pysequoia";
    rev = "v${version}";
    hash = "sha256-63kUUxZTG33cB/IiD4AiDpLOI6Uew/fETgqhaGc7zp0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-S/j3bGgU46nvVQFs35ih05teVEIJrFN4Ryq4B7rLFDE=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs = [
    bzip2
    nettle
    openssl
    pcsclite
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  pythonImportsCheck = [ "pysequoia" ];

  meta = with lib; {
    description = "This library provides OpenPGP facilities in Python through the Sequoia PGP library";
    homepage = "https://sequoia-pgp.gitlab.io/pysequoia";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
