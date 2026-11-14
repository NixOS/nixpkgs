{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  git,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "try-rs";
  version = "1.7.11";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tassiovirginio";
    repo = "try-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ESr9lse0QP924NVl35fzg/5zu31gY4UYL69Yv6xAKc=";
  };

  cargoHash = "sha256-kDJrszhqSdG0pdR8CNKpViv7sg/ENRf9RWhJnrevKFk=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  nativeCheckInputs = [ git ];

  installPhase = ''
    runHook preInstall

    wrapProgram $out/bin/try-rs \
      --prefix PATH ":" ${lib.makeBinPath [ git ]}

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd try-rs \
      --bash <($out/bin/try-rs --completions bash) \
      --fish <($out/bin/try-rs --completions fish) \
      --zsh <($out/bin/try-rs --completions zsh) \
      --nushell <($out/bin/try-rs --completions nu-shell)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Workspace manager for your temporary experiments";
    homepage = "https://try-rs.org/";
    downloadPage = "https://github.com/tassiovirginio/try-rs";
    changelog = "https://github.com/tassiovirginio/try-rs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "try-rs";
  };
})
