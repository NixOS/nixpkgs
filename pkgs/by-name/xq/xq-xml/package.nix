{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "xq";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "sibprogrammer";
    repo = "xq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cDZdQ0gmyx3h64l+HlPKj9AJVyKR5EGFPaNU+4xX0pw=";
  };

  vendorHash = "sha256-ZYZgac2AW7Yjy3wYjh+VXK5Ng7+CBZebn4bUX2lt2sc=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.commit=v${finalAttrs.version}"
    "-X=main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line XML and HTML beautifier and content extractor";
    mainProgram = "xq";
    homepage = "https://github.com/sibprogrammer/xq";
    changelog = "https://github.com/sibprogrammer/xq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
