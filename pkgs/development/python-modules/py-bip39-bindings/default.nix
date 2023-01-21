{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, pythonOlder
, pytestCheckHook
, rustPlatform
, stdenv
, libiconv }:

buildPythonPackage rec {
  pname = "py-bip39-bindings";
  version = "0.1.10";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "polkascan";
    repo = "py-bip39-bindings";
    rev = "ddb74433c2dca7b1f1e1984c33b9da7b51a30227";
    sha256 = "sha256-MBDic955EohTW6BWprv7X+ZPHoqzkyBJYKV4jpNPKz8=";
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
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "bip39"
  ];

  meta = with lib; {
    description = "Python bindings for the tiny-bip39 library";
    homepage = "https://github.com/polkascan/py-bip39-bindings";
    license = licenses.asl20;
    maintainers = with maintainers; [ stargate01 ];
  };
}
