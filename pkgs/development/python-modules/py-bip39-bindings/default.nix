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
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "polkascan";
    repo = "py-bip39-bindings";
    tag = "v${version}";
    hash = "sha256-jpBlupIjlH2LJkSm3tzxrH5wT2+eziugNMR4B01gSdE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-qX4ydIT2+8dJQIVSYzO8Rg8PP61cu7ZjanPkmI34IUY=";
  };

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
