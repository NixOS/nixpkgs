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
  version = "0.5.post0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cher-nov";
    repo = "cryptg";
    rev = "v${version}";
    hash = "sha256-GCTVxCJQvpvHpzaU+OaFM/AKoRvxLyA0u6VIV+94UTY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-+RNH9h40UTGUcr0PPJLllhAg81LM1IQnYKmrNxfPPv8=";
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
