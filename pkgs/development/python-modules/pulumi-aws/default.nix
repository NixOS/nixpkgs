{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  parver,
  pulumi,
  semver,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pulumi-aws";
  # Version is independent of pulumi's.
  version = "7.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-aws";
    tag = "v${version}";
    hash = "sha256-aCTXhaWQgYcDyUMc6ulo/PtEGU/6Mb5MlIjtJI/V1Mw=";
  };

  sourceRoot = "${src.name}/sdk/python";

  postPatch = ''
    # We need the version of pulumi-aws in its package metadata to be accurate
    # as this seems to be used to determine which version of the
    # pulumi-resource-aws plugin to be dynamically downloaded by the pulumi CLI
    substituteInPlace pyproject.toml \
      --replace-fail "7.0.0a0+dev" "${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    parver
    pulumi
    semver
  ];

  # Checks require cloud resources
  doCheck = false;

  pythonImportsCheck = [ "pulumi_aws" ];

  meta = {
    description = "Pulumi python amazon web services provider";
    homepage = "https://github.com/pulumi/pulumi-aws";
    changelog = "https://github.com/pulumi/pulumi-aws/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
