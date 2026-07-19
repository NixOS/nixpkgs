{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  runCommand,
  makeWrapper,
  tflint,
  tflint-plugins,
  symlinkJoin,
}:

buildGoModule (finalAttrs: {
  pname = "tflint";
  version = "0.63.1";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = "tflint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HFzifDEhwr9C/A8xNMyF7k3qbKkpBLLJWXpcIbvTo6Y=";
  };

  vendorHash = "sha256-73JuhXBVjCHYPcEyGsBlJZG4EVEf5zF0Hm5Nkrc/yJk=";

  doCheck = false;

  env.CGO_ENABLED = 0;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

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
    maintainers = [ ];
  };
})
