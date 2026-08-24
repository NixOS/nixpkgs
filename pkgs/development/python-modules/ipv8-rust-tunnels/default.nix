{
  lib,
  buildPythonPackage,
  fetchPypi,
  perl,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "ipv8-rust-tunnels";
  version = "0.1.53";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "ipv8_rust_tunnels";
    hash = "sha256-A95LhuZoLHCW9IcDVnL/QyHursaUKC3GCIXkYHVdwIU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-aPLwXECgEumulnCc9dw/18EE+UUgw4uQ7FZAbe0IKAI=";
  };

  # pyo3 0.23 has no python 3.14 support yet.
  env = {
    PYO3_USE_ABI3_FORWARD_COMPATIBILITY = true;
    RUSTFLAGS = "--cfg tokio_unstable";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    perl
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ipv8_rust_tunnels" ];

  meta = {
    description = "Set of performance enhancements to the TunnelCommunity, the anonymization layer used in IPv8 and Tribler";
    homepage = "https://github.com/Tribler/ipv8-rust-tunnels";
    changelog = "https://github.com/Tribler/ipv8-rust-tunnels/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ mlaradji ];
  };
})
