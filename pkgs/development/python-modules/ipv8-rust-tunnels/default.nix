{
  lib,
  rustPlatform,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "ipv8-rust-tunnels";
  version = "0.1.44";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ipv8_rust_tunnels";
    hash = "sha256-eHk8aCrcnyVGd3JRGQ950Bwryqt+TYx84MHAM2kWTis=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-axWG5cJtNaoZl7cG+Zyo1k+eA8pXHDWFgHqpTmQNHlo=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  meta = with lib; {
    description = "A set of performance enhancements to the TunnelCommunity, the anonymization layer used in IPv8 and Tribler";
    homepage = "https://github.com/Tribler/ipv8-rust-tunnels";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ mlaradji ];
  };
}
