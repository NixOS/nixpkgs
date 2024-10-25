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
  version = "0.15.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    hash = "sha256-0WYgShihTBM0e+MIhON0dnhZug6l280tZcVp3KF1Jq0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-AgHfCKLna30WERAFGEs8yRxxZHwvLzR+/S+ivwKHXXE=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [ numpy ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  checkInputs = [
    fixtures
    networkx
    testtools
  ];

  pythonImportsCheck = [ "rustworkx" ];

  meta = with lib; {
    description = "High performance Python graph library implemented in Rust";
    homepage = "https://github.com/Qiskit/rustworkx";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
