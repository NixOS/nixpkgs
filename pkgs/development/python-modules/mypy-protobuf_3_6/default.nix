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
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nipunn1313";
    repo = "mypy-protobuf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-io28P01wvV9y9ool4RQUV7ODb/r5ZeBhZb5ZUsi3m4M=";
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
