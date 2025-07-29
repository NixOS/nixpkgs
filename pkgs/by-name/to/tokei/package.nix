{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fetchpatch2,
  libiconv,
  zlib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tokei";
  version = "13.0.0-alpha.8";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = "tokei";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jCI9VM3y76RI65E5UGuAPuPkDRTMyi+ydx64JWHcGfE=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/XAMPPRocky/tokei/pull/1209
      url = "https://github.com/XAMPPRocky/tokei/commit/ce8d8535276a2e41878981a8199232986ab96c6b.patch";
      hash = "sha256-1tb+WmjVsTxs8Awf1mbKOBIhJ3ddoOT8ZjBKA2BMocg=";
    })
  ];

  cargoHash = "sha256-LzlyrKaRjUo6JnVLQnHidtI4OWa+GrhAc4D8RkL+nmQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  checkInputs = lib.optionals stdenv.hostPlatform.isDarwin [ zlib ];

  # enable all output formats
  buildFeatures = [ "all" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

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
