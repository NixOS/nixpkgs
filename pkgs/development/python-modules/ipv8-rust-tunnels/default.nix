{
  lib,
  rustPlatform,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "ipv8-rust-tunnels";
  version = "0.1.33";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ipv8_rust_tunnels";
    hash = "sha256-LwQL/u+h6mwCo207OxSk9YKxuLuxXQhh07rSWrNFh7w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-NwYLez9NFgS0GBXrcNrKJKV+s4HIHM8jHXfmkgya03M=";
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
