{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-06-21";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "6a7fc1b9483f289d73ea969804e07b9218df0f69";
    hash = "sha256-Uxn74nxVUjxvCI3NfQn03j3Ftk1yqjs3bS/Iglwgk7A=";
  };

  cargoHash = "sha256-+CeQLQMg14PVWBMedDB1Z8Tbs1XaN2ZAfBwG3Vz5bIM=";

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
