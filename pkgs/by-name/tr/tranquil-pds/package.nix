{
  lib,
  fetchgit,
  rustPlatform,
  pkg-config,
  openssl,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tranquil-pds";
  version = "0.6.3";

  src = fetchgit {
    url = "https://tangled.org/tranquil.farm/tranquil-pds";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TORNOFPlbCt4QWNd+bmxkShTUvT/5ynOj+UBYITAhg8=";
  };

  cargoHash = "sha256-tQk9WQZmaG2XEx5gocPhYd8fZ2cikvduhln5h/w+WZA=";

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

  meta = {
    description = "Tranquil ATProto Personal Data Server implementation written in Rust";
    homepage = "https://tangled.org/tranquil.farm/tranquil-pds";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ nelind ];
    mainProgram = "tranquil-server";
  };
})
