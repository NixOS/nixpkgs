{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, rustPlatform
, setuptools-rust
, libiconv
}:

buildPythonPackage rec {
  pname = "cryptg";
  version = "0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cher-nov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2HP1mKGPr8wOL5B0APJks3EVBicX2iMFI7vLJGTa1PM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-AqSVFOB9Lfvk9h3GtoYlEOXBEt7YZYLhCDNKM9upQ2U=";
  };

  nativeBuildInputs = with rustPlatform;[
    setuptools-rust
    cargoSetupHook
    rust.rustc
    rust.cargo
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "cryptg" ];

  meta = with lib; {
    description = "Official Telethon extension to provide much faster cryptography for Telegram API requests";
    homepage = "https://github.com/cher-nov/cryptg";
    license = licenses.cc0;
    maintainers = with maintainers; [ nickcao ];
  };
}
