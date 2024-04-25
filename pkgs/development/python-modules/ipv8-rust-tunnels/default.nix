{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libiconv,
  pytestCheckHook,
  rustPlatform,
  stdenv,
}:

buildPythonPackage rec {
  pname = "ipv8-rust-tunnels";
  version = "0.1.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tribler";
    repo = pname;
    rev = version;
    hash = "sha256-HJFYxJpb1OklqGtO/kpDVoT+/v0h1oW6BMPZglz5P2w=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  pythonImportsCheck = [ "ipv8_rust_tunnels" "ipv8_rust_tunnels.rust_endpoint" ];

  meta = with lib; {
    description = "Rust implemntation of IPv8 TunnelCommunity enhancements, the anonymization layer used by IPv8 and Tribler.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ RaghavSood ];
  };
}


