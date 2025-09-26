{
  lib,
  pulumiPackages,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  parver,
  pulumi,
  semver,
  typing-extensions,
}:
let
  inherit (pulumiPackages) pulumi-command;
  src = pulumi-command.sdk;
  sourceRoot = "${src.name}-sdk/python";
in
buildPythonPackage {
  inherit (pulumi-command) pname version;
  inherit src sourceRoot;

  outputs = [
    "out"
    "dev"
  ];

  pyproject = true;

  disabled = pythonOlder "3.9";

  build-system = [ setuptools ];

  dependencies = [
    parver
    pulumi
    semver
  ]
  ++ lib.optional (pythonOlder "3.11") typing-extensions;

  pythonImportsCheck = [ "pulumi_command" ];

  meta = {
    description = "Pulumi provider to execute commands and scripts either locally or remotely as part of the Pulumi resource model";
    homepage = "https://github.com/pulumi/pulumi-command";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      veehaitch
      trundle
      tie
    ];
  };
}
