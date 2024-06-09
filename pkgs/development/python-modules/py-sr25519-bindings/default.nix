{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  rustPlatform,
  stdenv,
  py-bip39-bindings,
  libiconv,
}:

buildPythonPackage rec {
  pname = "py-sr25519-bindings";
  version = "unstable-2023-03-15";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "polkascan";
    repo = "py-sr25519-bindings";
    rev = "9127501235bf291d7f14f00ec373d0a5000a32cb";
    hash = "sha256-mxNmiFvMbV9WQhGNIQXxTkOcJHYs0vyOPM6Nd5367RE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-7fDlEYWOiRVpG3q0n3ZSS1dfNCOh0/4pX/PbcDBvoMI=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  nativeCheckInputs = [
    pytestCheckHook
    py-bip39-bindings
  ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "sr25519" ];

  meta = with lib; {
    description = "Python bindings for sr25519 library";
    homepage = "https://github.com/polkascan/py-sr25519-bindings";
    license = licenses.asl20;
    maintainers = with maintainers; [
      onny
      stargate01
    ];
  };
}
