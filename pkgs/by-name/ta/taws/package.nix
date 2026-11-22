{
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "taws";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "huseyinbabal";
    repo = "taws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-76dC5ZLhQkItqGdWkq+U8mzimjDAAkzzpopx8ZPHCx4=";
  };

  cargoHash = "sha256-62Pk1RRx0eErGWNCYEyw0jFoNp97a+1kn5brgd81P5k=";

  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall =
    let
      taws =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/taws"
        else
          lib.getExe buildPackages.taws;
    in
    ''
      installShellCompletion --cmd taws \
        --bash <(${taws} completion bash) \
        --fish <(${taws} completion fish) \
        --zsh <(${taws} completion zsh)
    '';

  meta = {
    description = "Terminal-based AWS resource viewer and manager";
    homepage = "https://github.com/huseyinbabal/taws";
    changelog = "https://github.com/huseyinbabal/taws/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "taws";
    maintainers = [ lib.maintainers.EpicEric ];
    platforms = lib.platforms.all;
  };
})
