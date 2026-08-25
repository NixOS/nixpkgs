{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-08-13";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "c3b4dbf67b95b3c26e3835da175c283ec4137c77";
    hash = "sha256-3MDiQBqw9ykOL49g9aIEIxU/ZrCAVLOPC4omA4R54V8=";
  };

  cargoHash = "sha256-5XrpmknZXrHGztzlzm0M6BGHL2uYuztojd6cWyTwWvk=";

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
