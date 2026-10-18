{
  lib,
  fetchFromTangled,
  rustPlatform,
  pkg-config,
  openssl,
  protobuf,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tranquil-pds";
  version = "0.7.0";

  src = fetchFromTangled {
    did = "did:plc:jj6ajj6duxnlthwtnob4qyuv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QbncR2z9GhxKKbbCf6a5Ph4lLi4OYWjRN49s7+5q7Uc=";
  };

  cargoHash = "sha256-fjT0cAt7lPD0O2PGNT604dRIczerKjExJvU/L3Yul3c=";

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
