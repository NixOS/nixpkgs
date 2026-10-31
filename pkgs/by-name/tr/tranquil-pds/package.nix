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
  version = "0.7.1";

  src = fetchFromTangled {
    did = "did:plc:jj6ajj6duxnlthwtnob4qyuv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qsV7AXQHITaWQ3lFGyvdukV8gcVoI4P02QWS4BsZxIQ=";
  };

  cargoHash = "sha256-K4wTFCEozwqAoaFFPhN6ZgonPB1FBuFDT9mjNHumHcs=";

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
