{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "064d238441a4ed20b0f6a82203b3920c0b39e8f8";
    hash = "sha256-Pu3ulcCw02dMp85YPpqwN2DX4La7TXnbhVbsNcBcK38=";
  };

  cargoHash = "sha256-EhUjlZ6xNMRcgUnsRNzSv3CYfDpVc0bxHZF9EFwzKi8=";

  checkFlags = [
    # Operation not supported
    "--skip=common::util::tests::test_compare_xattrs"
    # assertion failed
    "--skip=test_setfacl::test_invalid_arg"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplementation of the acl project";
    homepage = "https://github.com/uutils/acl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
