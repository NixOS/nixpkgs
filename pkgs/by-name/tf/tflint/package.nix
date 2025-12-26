{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  versionCheckHook,
  runCommand,
  makeWrapper,
  tflint,
  tflint-plugins,
  symlinkJoin,
}:

buildGo125Module (finalAttrs: {
  pname = "tflint";
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = "tflint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hf4C8DaI+u7cAbOiQ6XvQLlF+Kl484TeJ1oJsvIw/wo=";
  };

  vendorHash = "sha256-aOa+FO3LA9S97wgbayAW3vY5ZCAqn72N8HxvVfThGY4=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru.withPlugins =
    plugins:
    let
      actualPlugins = plugins tflint-plugins;
      pluginDir = symlinkJoin {
        name = "tflint-plugin-dir";
        paths = [ actualPlugins ];
      };
    in
    runCommand "tflint-with-plugins-${finalAttrs.version}"
      {
        nativeBuildInputs = [ makeWrapper ];
        inherit (finalAttrs) version;
      }
      ''
        makeWrapper ${tflint}/bin/tflint $out/bin/tflint \
          --set TFLINT_PLUGIN_DIR "${pluginDir}"
      '';

  meta = {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    mainProgram = "tflint";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
