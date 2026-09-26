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
  version = "0.15.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "johannus22";
    repo = "zentra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yVQmpFYNE/AQ9uETRfmHA3b19TEf7+gxGM4yQBfGisc=";
  };

  cargoHash = "sha256-0q2aWcwBiGNormTaT0KfsfN1xI1+8SmnBO8HLjj4vAc=";

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

  checkFlagsArray = [
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
