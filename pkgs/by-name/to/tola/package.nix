{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  aws-lc,
  libgit2,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "tola";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "tola-rs";
    repo = "tola-ssg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qd0OlY7GK0aONzF7e+nVZBBw7u6W1z+g//VwsaJEMbw=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    aws-lc
    libgit2
    openssl
    sqlite
  ];

  cargoHash = "sha256-MNkfhiQf9Rt9kTkwxjmPCgnjMizuztn4Gf/Y6qQK9tE=";

  # Tests bind localhost TCP listeners on macOS.
  __darwinAllowLocalNetworking = true;

  # In the Darwin sandbox, FSEvents is not available.  Therefore, we only turn on tests that
  # require it if we are not on the Darwin platform.
  checkFeatures = lib.optional (!stdenv.hostPlatform.isDarwin) "fsevents-tests";

  # Skip tests that require network access.
  checkFlags = [
    "--skip=icon::tests::remote_collection_lock_and_invalidate"
    "--skip=resources::tests::resources_drop_inside_async_host"
  ];

  cargoTestFlags = [ "--workspace" ];

  meta = {
    description = "Typst-based static site generator";
    homepage = "https://tola.build";
    license = lib.licenses.mit;
    mainProgram = "tola";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      kawayww
      matthiasbeyer
      jthulhu
    ];
  };
})
