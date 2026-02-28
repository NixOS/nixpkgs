{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-02-19";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "c417e350e7280a6ac41e26d8d658fc78e8abaf97";
    hash = "sha256-H/yYSAfV0o5Qt/KdGMqGhvUYXq5JRx4fReMuK1tHFAQ=";
  };

  cargoHash = "sha256-p0JDeNLKkjmGsZ9fF/9Xm+0pc00pzY8pgWb4B82D6vE=";

  cargoBuildFlags = [ "--workspace" ];

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
