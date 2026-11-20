{
  lib,
  dbus,
  fetchFromGitHub,
  gitMinimal,
  makeWrapper,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zentra";
  version = "0.16.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "johannus22";
    repo = "zentra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4gKg91pVMHHiJiorpNwojhfwSO652eGzAYcn1bojHI=";
  };

  cargoHash = "sha256-nWw0Llc8+lomBMKcf0MJ86ASqHpmIfXdWTKSAtL6K/A=";

  nativeBuildInputs = [
    gitMinimal
    makeWrapper
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    dbus
    openssl
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  postFixup = ''
    wrapProgram $out/bin/zentra --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  checkFlags = [
    # Some details are missing for these tests
    "--skip=incremental::detect::tests::compute_change_set_git_includes_committed_and_dirty"
    "--skip=incremental::detect::tests::working_tree_changes_includes_non_ascii_filename"
    "--skip=incremental::detect::tests::working_tree_changes_lists_modified_and_untracked"
  ];

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "CLI agent harness tool designed to assist with SAST and DAST";
    homepage = "https://github.com/johannus22/zentra";
    changelog = "https://github.com/johannus22/zentra/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "zentra";
  };
})
