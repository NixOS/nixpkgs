{
  lib,
  fetchgit,
  rustPlatform,
  pkg-config,
  openssl,
  protobuf,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tranquil-pds";
  version = "0.6.5";

  src = fetchgit {
    url = "https://tangled.org/tranquil.farm/tranquil-pds";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kBy982B9ZY5W02hmdKqlR86ynJAUD98b4UgaYIPaFzM=";
  };

  cargoHash = "sha256-X2zoQSBQaq+W0rT/Y08EA1b81pbePUvH7q+Ccmtbf+Y=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    openssl
  ];

  # the tranquil test suite has shown itself virtually impossible to complete on most hardware thus stopping reviews.
  # disable the check phase for now
  doCheck = false;

  passthru.tests = { inherit (nixosTests) tranquil-pds; };

  meta = {
    description = "Tranquil ATProto Personal Data Server implementation written in Rust";
    homepage = "https://tangled.org/tranquil.farm/tranquil-pds";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ nelind ];
    mainProgram = "tranquil-server";
  };
})
