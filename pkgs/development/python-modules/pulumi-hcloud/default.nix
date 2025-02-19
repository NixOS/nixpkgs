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
  inherit (pulumiPackages) pulumi-hcloud;
  src = pulumi-hcloud.sdk;
  sourceRoot = "${src.name}-sdk/python";
in
buildPythonPackage {
  inherit (pulumi-hcloud) pname version;
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

  pythonImportsCheck = [ "pulumi_hcloud" ];

  meta = {
    description = "Pulumi package for creating and managing Hetzner Cloud resources";
    homepage = "https://github.com/pulumi/pulumi-hcloud";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      albertodvp
      tie
    ];
  };
}
