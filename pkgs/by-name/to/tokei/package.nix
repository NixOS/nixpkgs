{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  zlib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tokei";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = "tokei";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VAFeMEuE4CdXRumj1TuHk5gu0QGbxTDY1Ys/tNeoGP4=";
  };

  cargoHash = "sha256-/1Hu/55KeLqfgHz6Q3cimfaLLwEiFksk34QGPPTU6tU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  checkInputs = lib.optionals stdenv.hostPlatform.isDarwin [ zlib ];

  # enable all output formats
  buildFeatures = [ "all" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Count your code, quickly";
    longDescription = ''
      Tokei is a program that displays statistics about your code. Tokei will show the number of files, total lines within those files and code, comments, and blanks grouped by language.
    '';
    homepage = "https://github.com/XAMPPRocky/tokei";
    changelog = "https://github.com/XAMPPRocky/tokei/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "tokei";
  };
})
