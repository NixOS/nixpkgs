{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, pythonOlder
, pytestCheckHook
, rustPlatform
, stdenv
, py-bip39-bindings
, libiconv }:

buildPythonPackage rec {
  pname = "py-sr25519-bindings";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "polkascan";
    repo = "py-sr25519-bindings";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Lu3J0+YeQHHKItOZTT24DlQAUJuE9fd+py6Eb46/MSE=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  nativeCheckInputs = [
    pytestCheckHook
    py-bip39-bindings
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "sr25519"
  ];

  meta = with lib; {
    description = "Python bindings for sr25519 library";
    homepage = "https://github.com/polkascan/py-sr25519-bindings";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny stargate01 ];
  };
}
