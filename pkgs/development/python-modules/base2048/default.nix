{ lib
, stdenv
, buildPythonPackage
, cargo
, fetchFromGitHub
, frelatage
, libiconv
, maturin
, pytestCheckHook
, pythonOlder
, rustc
, rustPlatform
}:

buildPythonPackage rec {
  pname = "base2048";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ionite34";
    repo = "base2048";
    rev = "refs/tags/v${version}";
    hash = "sha256-OXlfycJB1IrW2Zq0xPDGjjwCdRTWtX/ixPGWcd+YjAg=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  passthru.optional-dependencies = {
    fuzz = [
      frelatage
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "base2048"
  ];

  meta = with lib; {
    description = "Binary encoding with base-2048 in Python with Rust";
    homepage = "https://github.com/ionite34/base2048";
    changelog = "https://github.com/ionite34/base2048/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
