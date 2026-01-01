{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
  callPackage,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typst";
<<<<<<< HEAD
  version = "0.14.2";
=======
  version = "0.14.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-EXcmL/KNj9vCChCs6RH1J/+aetYcXnEdGEhvVzGNNZA=";
=======
    hash = "sha256-Sdl60VNjrSVj8YFZR/b2WOzN8taZ6wsJx5FnED9XQbw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse HEAD > COMMIT
      rm -rf .git
    '';
  };

<<<<<<< HEAD
  cargoHash = "sha256-HDu7/kgpBgUe/CrHm17BkNlg3DYlegTevgAeBCXp6so=";
=======
  cargoHash = "sha256-6o7IbDBJU+FGYezfm37Z4eBBWa7G06vFbopI0FqJu7c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
    OPENSSL_NO_VENDOR = true;
  };

  # Fix for "Found argument '--test-threads' which wasn't expected, or isn't valid in this context"
  postPatch = ''
    substituteInPlace tests/src/tests.rs --replace-fail \
      'ARGS.num_threads' \
      'ARGS.test_threads'
    substituteInPlace tests/src/args.rs --replace-fail \
      'num_threads' \
      'test_threads'
    substituteInPlace crates/typst-cli/build.rs --replace-fail \
      '"cargo:rustc-env=TYPST_COMMIT_SHA={}", typst_commit_sha()' \
      "\"cargo:rustc-env=TYPST_COMMIT_SHA={}\", \"$(cat COMMIT | cut -c1-8)\""
  '';

  postInstall = ''
    installManPage crates/typst-cli/artifacts/*.1
    installShellCompletion \
      crates/typst-cli/artifacts/typst.{bash,fish} \
      --zsh crates/typst-cli/artifacts/_typst
  '';

  cargoTestFlags = [ "--workspace" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    updateScript = nix-update-script { };
    packages = callPackage ./typst-packages.nix { };
    withPackages = callPackage ./with-packages.nix { };
  };

  meta = {
    changelog = "https://github.com/typst/typst/releases/tag/v${finalAttrs.version}";
    description = "New markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://github.com/typst/typst";
    license = lib.licenses.asl20;
    mainProgram = "typst";
    maintainers = with lib.maintainers; [
      kanashimia
      RossSmyth
    ];
  };
})
