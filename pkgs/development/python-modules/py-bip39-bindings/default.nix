{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  rustPlatform,
  stdenv,
  libiconv,
}:

buildPythonPackage rec {
  pname = "py-bip39-bindings";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "polkascan";
    repo = "py-bip39-bindings";
    tag = "v${version}";
    hash = "sha256-CglVEvmZ8xYtjFPNhCyzToYrOvGe/Sw3zHAIy1HidzM=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "bip39" ];

  meta = with lib; {
    description = "Python bindings for the tiny-bip39 library";
    homepage = "https://github.com/polkascan/py-bip39-bindings";
    license = licenses.asl20;
    maintainers = with maintainers; [ stargate01 ];
  };
}
