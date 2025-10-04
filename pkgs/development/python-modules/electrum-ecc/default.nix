{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pkgs,
  pytestCheckHook,
}:

let
  libsecp256k1_name =
    if stdenv.hostPlatform.isLinux then
      "libsecp256k1.so.{v}"
    else if stdenv.hostPlatform.isDarwin then
      "libsecp256k1.{v}.dylib"
    else
      "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";
in
buildPythonPackage rec {
  pname = "electrum-ecc";
  version = "0.0.5";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    pname = "electrum_ecc";
    inherit version;
    hash = "sha256-9zO4WWoPeyXINx0Ir2Hvece4cdW0DwWluV0tBesvt9I=";
  };

  env = {
    # Prevent compilation of the C extension as we use the system library instead.
    ELECTRUM_ECC_DONT_COMPILE = "1";
  };

  postPatch = ''
    # remove bundled libsecp256k1
    rm -rf libsecp256k1/
    # use the system library instead
    substituteInPlace ./src/electrum_ecc/ecc_fast.py \
      --replace-fail ${libsecp256k1_name} ${pkgs.secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "electrum_ecc" ];

  meta = with lib; {
    description = "Pure python ctypes wrapper for libsecp256k1";
    homepage = "https://github.com/spesmilo/electrum-ecc";
    license = licenses.mit;
    maintainers = [ ];
  };
}
