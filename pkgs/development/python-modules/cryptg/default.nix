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
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cher-nov";
    repo = "cryptg";
    rev = "v${version}";
    hash = "sha256-4WerXUEkdkIkVEyZB4EzM1HITvNbO7a1Cfi3bpJGUVA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-kR92lvyBCFxEvIlzRX796XQn71ARrlsfK+fAKrwimEo=";
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
