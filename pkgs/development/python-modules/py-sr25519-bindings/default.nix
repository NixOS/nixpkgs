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
  version = "0.1.5";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "polkascan";
    repo = "py-sr25519-bindings";
    rev = "a97398b386c10ebe0a1f6c45dea466add0d407ce";
    sha256 = "sha256-RJfwWeD82J5QqY+qq2bC3vlqT75jUwhTXuIsza4qUzk=";
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

  checkInputs = [
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
