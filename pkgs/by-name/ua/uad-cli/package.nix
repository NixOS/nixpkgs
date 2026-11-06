{
  lib,
  stdenv,
  android-tools,
  installShellFiles,
  makeWrapper,
  rustPlatform,
  universal-android-debloater,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage {
  pname = "uad-cli";
  inherit (universal-android-debloater) version src cargoDeps;

  __structuredAttrs = true;

  cargoBuildFlags = [ "--package=uad-cli" ];
  cargoTestFlags = [
    "--package=uad-cli"
    "--package=uad-core"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  postInstall = ''
    wrapProgram $out/bin/uad --suffix PATH : ${lib.makeBinPath [ android-tools ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      $out/bin/uad completions "$shell" > "uad.$shell"
      installShellCompletion --cmd uad --"$shell" "uad.$shell"
    done
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    inherit (universal-android-debloater.meta)
      changelog
      homepage
      license
      platforms
      ;
    description = "Command-line interface for Universal Android Debloater";
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "uad";
  };
}
