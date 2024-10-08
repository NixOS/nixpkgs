{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  rustPlatform,
  stdenv,
  libiconv,
}:

buildPythonPackage rec {
  pname = "py-bip39-bindings";
  version = "0.1.11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "polkascan";
    repo = "py-bip39-bindings";
    rev = "refs/tags/v${version}";
    hash = "sha256-3/KBPUFVFkJifunGWJeAHLnY08KVTb8BHCFzDqKWH18=";
  };

  patches = [
    (fetchpatch {
      name = "update-to-latest-maturin-and-pyo3.patch";
      url = "https://github.com/polkascan/py-bip39-bindings/commit/f05cced028b43b59cfa67e17fbf0f337bdd3aa8d.patch";
      hash = "sha256-/pFNSFtYyKiOoIDVqEWdZCbQxFZ7FIcvAHY2m5STlEc=";
    })
  ];

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

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "bip39" ];

  meta = with lib; {
    description = "Python bindings for the tiny-bip39 library";
    homepage = "https://github.com/polkascan/py-bip39-bindings";
    license = licenses.asl20;
    maintainers = with maintainers; [ stargate01 ];
  };
}
