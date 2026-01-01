{
  lib,
  stdenv,
  fetchFromGitHub,
  rust-jemalloc-sys,
  installShellFiles,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zizmor";
<<<<<<< HEAD
  version = "1.19.0";
=======
  version = "1.16.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-GWAjz/RYShjSFgQP1I3AxwVkiUJ9iwhT5R7UIHaLDuk=";
  };

  cargoHash = "sha256-Zd1lTUtfJf2p6MkscHgpEHvmLufnQYSWoYcQqn0ap+g=";
=======
    hash = "sha256-WoTCG7C6dTYfh49vL2Mh7c4tkXIqV1gJum3qHHKkq4k=";
  };

  cargoHash = "sha256-pq0NR6YHIn5ftQWXD3tIkWgm7DqhMR076394WouhCIw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildInputs = [
    rust-jemalloc-sys
  ];

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zizmor \
      --bash <("$out/bin/zizmor" --completions bash) \
      --zsh <("$out/bin/zizmor" --completions zsh) \
      --fish <("$out/bin/zizmor" --completions fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
<<<<<<< HEAD
    extraArgs = [ "--version-regex=^v([0-9.]+\\.[0-9.]+\\.[0-9.])+$" ];
=======
    extraArgs = [ "--version-regex=^v([0-9.]+\.[0-9.]+\.[0-9.])+$" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Tool for finding security issues in GitHub Actions setups";
    homepage = "https://docs.zizmor.sh/";
    changelog = "https://github.com/zizmorcore/zizmor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "zizmor";
  };
})
