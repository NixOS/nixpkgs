{
  lib,
  fetchFromTangled,
  rustPlatform,
  pkg-config,
  openssl,
  zstd,
  protobuf,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tranquil-pds";
  version = "0.8.0";

  src = fetchFromTangled {
    did = "did:plc:jj6ajj6duxnlthwtnob4qyuv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0/eBbeO31lCI99TNSSQlk9QaWzegpAuYyGCQMupPb9s=";
  };

  cargoHash = "sha256-r6j925a6PfVKNLg60vxKRVw4rddLsGtQ0G2/KvyGw3Q=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    openssl
    zstd
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
