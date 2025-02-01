{
  fetchFromGitHub,
  buildPythonPackage,
  cargo,
  rustPlatform,
  rustc,
  setuptools-rust,
  numpy,
  fixtures,
  networkx,
  testtools,
  libiconv,
  stdenv,
  lib,
}:

buildPythonPackage rec {
  pname = "rustworkx";
  version = "0.14.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    hash = "sha256-gck5X6J4Yg5it/YCBsk/yZ5qXg/iwCEbyDIKfBTRxHM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-FNCa5pshcnsYpjlz6yDITe2k0cHLTybj3rF34qrsRVU=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [ numpy ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  checkInputs = [
    fixtures
    networkx
    testtools
  ];

  pythonImportsCheck = [ "rustworkx" ];

  meta = with lib; {
    description = "A high performance Python graph library implemented in Rust";
    homepage = "https://github.com/Qiskit/rustworkx";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
