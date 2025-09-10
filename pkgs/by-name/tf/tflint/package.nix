{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  runCommand,
  makeWrapper,
  tflint,
  tflint-plugins,
  symlinkJoin,
}:

let
  pname = "tflint";
  version = "0.59.1";
in
buildGo125Module {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = "tflint";
    tag = "v${version}";
    hash = "sha256-tE8h0sAKCJEZzZqUAcgyVWVRXdG3F7F1Vh7Je0+0Xeg=";
  };

  vendorHash = "sha256-KVKxtH/Hgxe7We3K8ArovsRDPz6a2wEfQ8Zx3ScCo74=";

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
    runCommand "tflint-with-plugins-${version}"
      {
        nativeBuildInputs = [ makeWrapper ];
        inherit version;
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
