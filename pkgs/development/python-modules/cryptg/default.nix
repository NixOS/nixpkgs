{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
}:

buildPythonPackage rec {
  pname = "cryptg";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cher-nov";
    repo = "cryptg";
    rev = "v${version}";
    hash = "sha256-jrJy51AfMmLjAyi9FXT3mCi8q1OIpuAdrSS9tmrv3fA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-yOfpFGAy7VsDQrkd13H+ha0AzfXQmzmkIuvzsvY9rfk=";
  };

  build-system = [
    setuptools
    setuptools-rust
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "cryptg" ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "setuptools[core]" "setuptools"
  '';

  meta = with lib; {
    description = "Official Telethon extension to provide much faster cryptography for Telegram API requests";
    homepage = "https://github.com/cher-nov/cryptg";
    license = licenses.cc0;
    maintainers = with maintainers; [ nickcao ];
  };
}
