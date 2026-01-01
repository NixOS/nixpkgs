{
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unftp";
<<<<<<< HEAD
  version = "0.15.2";
=======
  version = "0.15.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bolcom";
    repo = "unftp";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-/2IzVr3QQl7UV3WjG1bWntYdx2RXqKWrTkcwIBgnCsk=";
  };

  cargoHash = "sha256-2Mwp/bK0JFdCtCDkAAdpFpf8zxE0ueZNXTkZDaamGyg=";
=======
    hash = "sha256-M6+4AYE2Wls2+LoPx3LSLHIWgWu9SMOIaNLVbXWKqGY=";
  };

  cargoHash = "sha256-P3TjRzo1TJE1LW+jbF0HOWeVXYsvwaZ+5CI+kH4jZNQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FTP(S) server with a couple of twists written in Rust";
    homepage = "https://unftp.rs/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "unftp";
  };
})
