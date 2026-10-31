{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tlrc";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7u1aaBEv9Rco/hVHOmpMrLlNapqHB2FBCL8SEyeB+Xs=";
  };

  cargoHash = "sha256-BbByF7AGKb/oiTDMSEutoHfmSA/55HrxFv+pDEWhaNw=";

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
