{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typeshare";
  version = "1.13.4";

  src = fetchFromGitHub {
    owner = "1password";
    repo = "typeshare";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8Pm+z407FDBLy0Hq2+T1rttFKnRWTNPPYTCn11SHcS8=";
  };

  cargoHash = "sha256-t5OJ4chxVhCRczfRPTZe2mkIDevSp7+1aVdplvJFCfg=";

  nativeBuildInputs = [ installShellFiles ];

  buildFeatures = [ "go" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd typeshare \
      --bash <($out/bin/typeshare completions bash) \
      --fish <($out/bin/typeshare completions fish) \
      --zsh <($out/bin/typeshare completions zsh)
  '';

  meta = {
    description = "Command Line Tool for generating language files with typeshare";
    mainProgram = "typeshare";
    homepage = "https://github.com/1password/typeshare";
    changelog = "https://github.com/1password/typeshare/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
  };
})
