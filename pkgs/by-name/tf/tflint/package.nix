{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  makeWrapper,
  tflint,
  tflint-plugins,
  symlinkJoin,
}:

let
  pname = "tflint";
  version = "0.54.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/eome0jF0l7Hb5c96c2S80I7DQGmyF09IgOEudpXMuE=";
  };

  vendorHash = "sha256-dYMfZcz4d+XWgnQ/u+BjNN2bFQnRNums7D0tTzYkC+Y=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.withPlugins =
    plugins:
    let
      actualPlugins = plugins tflint-plugins;
      pluginDir = symlinkJoin {
        name = "tflint-plugin-dir";
        paths = [ actualPlugins ];
      };
    in
    runCommand "tflint-with-plugins"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        makeWrapper ${tflint}/bin/tflint $out/bin/tflint \
          --set TFLINT_PLUGIN_DIR "${pluginDir}"
      '';

  meta = {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    mainProgram = "tflint";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
