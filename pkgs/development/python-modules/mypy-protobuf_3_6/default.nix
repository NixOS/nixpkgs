{
  buildPythonPackage,
  fetchFromGitHub,
  grpcio-tools,
  lib,
  protobuf,
  pytestCheckHook,
  setuptools,
  types-protobuf,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mypy-protobuf";
  version = "3.6.0";
  # nixpkgs-update: no auto update
  # this is a pinned version
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nipunn1313";
    repo = "mypy-protobuf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YBm/qfmas0kPmzhlgAwCdT8nsnC45fj2bhK3cXpvANo=";
  };

  pythonRelaxDeps = [ "protobuf" ];

  build-system = [ setuptools ];

  dependencies = [
    grpcio-tools
    protobuf
    types-protobuf
  ];

  doCheck = false; # ModuleNotFoundError: No module named 'testproto'

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mypy_protobuf" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/nipunn1313/mypy-protobuf/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/nipunn1313/mypy-protobuf";
    license = lib.licenses.asl20;
    mainProgram = "protoc-gen-mypy";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
