{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tlrc";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wYoxawZ9kfmWt02ONiN8Evq0TqI1XGDnY7vhQixySHo=";
  };

  cargoHash = "sha256-vrbNSow+DFOfJW1P/SSRm7V7Btzml7amWJ08JUXOZfg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage tldr.1
    installShellCompletion completions/{tldr.bash,_tldr,tldr.fish}
  '';

  meta = {
    description = "Official tldr client written in Rust";
    homepage = "https://github.com/tldr-pages/tlrc";
    changelog = "https://github.com/tldr-pages/tlrc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tldr";
    maintainers = with lib.maintainers; [ acuteenvy ];
  };
})
