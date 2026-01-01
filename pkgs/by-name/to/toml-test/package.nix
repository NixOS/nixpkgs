{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "toml-test";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "1.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "toml-lang";
    repo = "toml-test";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-J5+JO+BrHzje3YmEC9WWA7U6fn+Eye4DQj/knVR+QhE=";
  };

  vendorHash = "sha256-JcTW21Zva/7Uvc5AvW9H1IxAcaw3AU0FAdtI3IOtZAc=";
=======
    hash = "sha256-jOFkSEDNvvx8svgyYYpAbveQsclMsQRKJ2ocA6ty1Kw=";
  };

  vendorHash = "sha256-yt5rwpYzO38wEUhcyG4G367Byek20Uz3u+buAazq/5A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X zgo.at/zli.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
  versionCheckProgramArg = "version";
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language agnostic test suite for TOML parsers";
    homepage = "https://github.com/toml-lang/toml-test";
    changelog = "https://github.com/toml-lang/toml-test/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yzx9
      defelo
    ];
    mainProgram = "toml-test";
  };
})
