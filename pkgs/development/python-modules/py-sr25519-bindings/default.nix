{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  rustPlatform,
  stdenv,
  py-bip39-bindings,
  libiconv,
}:

buildPythonPackage rec {
  pname = "py-sr25519-bindings";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "polkascan";
    repo = "py-sr25519-bindings";
    rev = "9127501235bf291d7f14f00ec373d0a5000a32cb";
    hash = "sha256-mxNmiFvMbV9WQhGNIQXxTkOcJHYs0vyOPM6Nd5367RE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-OSnPGRZwuAzcvu80GgTXdc740SfhDIsXrQZq9a/BCdE=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [
    pytestCheckHook
    py-bip39-bindings
  ];

  enabledTestPaths = [ "tests.py" ];

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
