{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  stdenv,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "castor";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lQJgkitWXO8pMS1Dt7wCp3d9krdWyF+gzvmt1zoKkxI=";
  };

  vendorHash = "sha256-G1ClyhYbvHGegZKqO98vK306Qg/yV2ko8+0ADB9LiL8=";

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  # castor loads castor.php from the working directory, so generate the
  # completions outside the source tree to prevent it
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    pushd "$(mktemp -d)"
    installShellCompletion --cmd castor \
      --bash <(php $out/bin/castor completion bash) \
      --fish <(php $out/bin/castor completion fish) \
      --zsh <(php $out/bin/castor completion zsh)
    popd
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/jolicode/castor/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "DX oriented task runner and command launcher built with PHP";
    homepage = "https://github.com/jolicode/castor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mykiwi ];
    mainProgram = "castor";
    broken = lib.versionOlder php.version "8.4";
  };
})
