{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-diffutils";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "diffutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-51XYg+RYPPzrmwKT3mnKDyWxYpqTyLXVvTuQ5JpWcok=";
  };

  cargoHash = "sha256-aeJKosJNmpbhcjXcbudgw20+q/oBmPgqJItNCTGjH2A=";

  # The tests call GNU patch by its Homebrew name on macOS; stdenv's patch is GNU patch
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/utils.rs \
      --replace-fail '"gpatch"' '"patch"'
  '';

  checkFlags = [
    # called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
    "--skip=ed_diff::tests::test_permutations"
    "--skip=ed_diff::tests::test_permutations_reverse"
    "--skip=ed_diff::tests::test_permutations_empty_lines"
  ];

  postInstall = ''
    ln -s $out/bin/diffutils $out/bin/cmp
    ln -s $out/bin/diffutils $out/bin/diff
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/diffutils 2>/dev/null | head -1 | grep -F 'diffutils ${finalAttrs.version}'

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/uutils/diffutils/releases/tag/v${finalAttrs.version}";
    description = "Drop-in replacement of diffutils in Rust";
    homepage = "https://github.com/uutils/diffutils";
    license = lib.licenses.mit;
    mainProgram = "diffutils";
    maintainers = with lib.maintainers; [ defelo ];
    platforms = lib.platforms.unix;
  };
})
