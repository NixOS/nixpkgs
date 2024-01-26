{ fetchFromGitHub
, buildPythonPackage
, cargo
, rustPlatform
, rustc
, setuptools-rust
, numpy
, fixtures
, networkx
, testtools
, libiconv
, stdenv
, lib
}:

buildPythonPackage rec {
  pname = "rustworkx";
  version = "0.13.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    hash = "sha256-WwQuvRMDGiY9VrWPfxL0OotPCUhCsvbXoVSCNhmIF/g=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-QuzBJyM83VtB6CJ7i9/SFE8h6JbxkX/LQ9lOFSQIidU=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [ numpy ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  checkInputs = [ fixtures networkx testtools ];

  pythonImportsCheck = [ "rustworkx" ];

  meta = with lib; {
    description = "A high performance Python graph library implemented in Rust";
    homepage = "https://github.com/Qiskit/rustworkx";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
