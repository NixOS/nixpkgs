{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "cryptg";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cher-nov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IhzwQrWu8k308ZZhWz4Z3FHAkSLTXiCydyiy0MPN8NI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-M2ySVqfgpgHktLh4t5Sh1UTBCzajlQiDku4O9azHJwk=";
  };

  nativeBuildInputs = with rustPlatform;[
    setuptools-rust
    cargoSetupHook
    rust.rustc
    rust.cargo
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
