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
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = "tflint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eI2tNhxYMd+jzWvkFkAGWYOEZPd5oJeZc4ap8qg5bMM=";
  };

  vendorHash = "sha256-Rfabyb8HdiMLsH6RiQrMfbtE2TzjnnJbEfm/hnkLTkY=";

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
