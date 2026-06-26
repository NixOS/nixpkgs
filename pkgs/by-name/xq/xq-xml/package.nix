{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "xq";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "sibprogrammer";
    repo = "xq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6iC5YhCppzlyp6o+Phq98gQj4LjQx/5pt2+ejOvGvTE=";
  };

  vendorHash = "sha256-EYAFp9+tiE0hgTWewmai6LcCJiuR+lOU74IlYBeUEf0=";

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
