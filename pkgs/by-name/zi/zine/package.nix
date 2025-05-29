{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "zine";
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pUoMMgZQ+oDs9Yhc1rQuy9cUWiR800DlIe8wxQjnIis=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6SIwOkLQ6rayhRQEMSCm72mMhGJ6NlIBq4aKukXURdM=";

  cargoPatches = [
    # fix build with rust 1.80+
    ./update-time-crate.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Simple and opinionated tool to build your own magazine";
    homepage = "https://github.com/zineland/zine";
    changelog = "https://github.com/zineland/zine/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      dit7ya
      figsoda
    ];
    mainProgram = "zine";
  };
}
