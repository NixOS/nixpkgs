{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-findutils";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "findutils";
    tag = finalAttrs.version;
    hash = "sha256-i+ryTF2hlZFbyFft/769c800FkzL26E4snUsxU79sKY=";
  };

  cargoPatches = [
    (fetchpatch2 {
      url = "https://github.com/uutils/findutils/commit/90845d95ceb12289a1b5ee50704ed66f2f7349c3.patch";
      hash = "sha256-sCqOzfa3R45tXTK3N4344qb8YRmiW0o/lZwqHoBvgl8=";
    })
  ];

  cargoHash = "sha256-TQRt1eecT500JaJB2P10T1yV+z2/T8cgTNtF9r5zQpg=";

  postInstall = ''
    rm $out/bin/testing-commandline
  '';

  checkFlags = [
    # assertion failed: deps.get_output_as_string().contains("./test_data/simple/subdir")
    "--skip=find::tests::test_find_newer_xy_before_changed_time"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/find";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/uutils/findutils/releases/tag/${finalAttrs.version}";
    description = "Rust implementation of findutils";
    homepage = "https://github.com/uutils/findutils";
    license = lib.licenses.mit;
    mainProgram = "find";
    maintainers = with lib.maintainers; [ defelo ];
    platforms = lib.platforms.unix;
  };
})
