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
  inherit (pulumiPackages) pulumi-yandex-unofficial;
  src = pulumi-yandex-unofficial.sdk;
  sourceRoot = "${src.name}-sdk/python";
in
buildPythonPackage {
  inherit (pulumi-yandex-unofficial) pname version;
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

  pythonImportsCheck = [ "pulumi_yandex_unofficial" ];

  meta = {
    description = "Unofficial Pulumi package for creating and managing Yandex Cloud resources";
    homepage = "https://github.com/pulumi/pulumi-yandex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
