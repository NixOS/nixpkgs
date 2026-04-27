{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wtcat";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "pervrosen";
    repo = "wtcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jmI5XA8DfsLOKbxsfCE3jSYXP9e2m5Ax4pUYCBDprKw=";
  };

  cargoPatches = [
    # https://github.com/pervrosen/wtcat/pull/1
    (fetchpatch2 {
      url = "https://github.com/pervrosen/wtcat/commit/b7e2d319147842dfe7246a512a7a2a6aade6d192.patch";
      hash = "sha256-5XFKgL7+xSs3entwEJMpaa3EgQefPAmkHs5zGDBFasM=";
    })
  ];

  __structuredAttrs = true;

  strictDeps = true;

  cargoHash = "sha256-DNy1Hz0g0HKDdnXjiLSmDGKaI6sONaxkNXy/zoXErlk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "WebTransport CLI";
    homepage = "https://github.com/pervrosen/wtcat";
    changelog = "https://github.com/pervrosen/wtcat/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wtcat";
  };
})
