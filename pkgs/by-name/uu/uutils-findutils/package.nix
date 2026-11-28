{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  oniguruma,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-findutils";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "findutils";
    tag = finalAttrs.version;
    hash = "sha256-WtPo8gRg1OnBhde8cvHMVCNJ9HPCUQ6nQUNpeQVMHjo=";
  };

  cargoHash = "sha256-+0haTOFy/QUI4jCedqyX7rCrpjSWutTSdLHKN1aLYdk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

  postInstall = ''
    rm $out/bin/testing-commandline
  '';

  checkFlags = map (t: "--skip=${t}") [
    # assertion failed: deps.get_output_as_string().contains("./test_data/simple/subdir")
    "find::tests::test_find_newer_xy_before_changed_time"

    # Rely on setuid permissions, which the nix restricts.
    "find::matchers::printf::tests::test_printf_permissions"
    "find::matchers::printf::tests::test_printf_permissions_precision_and_flags"
    "find_ls_shows_file_type_and_special_bits"

    # The explicitly configured PATH (`tools/bin`, /usr/bin`, `/bin`) does not guarantee an external `true` executable on NixOS.
    "exec_accepts_relative_path_entries"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/uutils/findutils/releases/tag/${finalAttrs.src.tag}";
    description = "Rust implementation of findutils";
    homepage = "https://github.com/uutils/findutils";
    license = lib.licenses.mit;
    mainProgram = "find";
    maintainers = with lib.maintainers; [
      defelo
      kybe236
    ];
    platforms = lib.platforms.unix;
  };
})
