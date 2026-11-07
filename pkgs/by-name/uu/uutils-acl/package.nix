{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-11-02";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "e49a8e5e0bd52510c7f5c3c73252ca92cefc7c46";
    hash = "sha256-cNW7j4ad69YIEfUT1KhTAInhyciWSxx7HDbCvcs82G0=";
  };

  cargoHash = "sha256-a+yNLaX7LJnyW1teKSt9pAXv8+cMN1uFEtouFqSORAU=";

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
