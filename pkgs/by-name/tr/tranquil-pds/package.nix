{
  lib,
  fetchFromTangled,
  rustPlatform,
  pkg-config,
  openssl,
  zstd,
  sqlite,
  protobuf,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tranquil-pds";
  version = "0.9.1";

  src = fetchFromTangled {
    did = "did:plc:jj6ajj6duxnlthwtnob4qyuv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G+8jFPbBzXLE40sC8oxfSUVU1T8aFlb6GJJ+nGvs1iY=";
  };

  cargoHash = "sha256-MHnKgrT30Wi4B+nlm8i0EVm++zK3Q1lZtExYNP2vsFU=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    openssl
    zstd
    sqlite
  ];

  # the tranquil test suite has shown itself virtually impossible to complete on most hardware thus stopping reviews.
  # disable the check phase for now
  doCheck = false;

  passthru.tests = { inherit (nixosTests) tranquil-pds; };

  meta = {
    description = "Tranquil ATProto Personal Data Server implementation written in Rust";
    homepage = "https://tangled.org/tranquil.farm/tranquil-pds";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      nelind
      pyrox0
    ];
    mainProgram = "tranquil-server";
  };
})
