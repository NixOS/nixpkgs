{
  buildPythonPackage,
  fetchFromGitHub,
  grpcio-tools,
  lib,
  mypy-protobuf,
  protobuf,
  pytestCheckHook,
  setuptools,
  testers,
  types-protobuf,
}:

buildPythonPackage (finalAttrs: {
  pname = "mypy-protobuf";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nipunn1313";
    repo = "mypy-protobuf";
    rev = "47fa102ae5d2bd2a1fdde2adf94cf006a3e939a4"; # not tagged, but on pypi
    hash = "sha256-VYDTJmiezHAVC3QV+HM7C5y5WaFvoInzupWhnB/iNgA=";
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

  passthru.tests.version = testers.testVersion {
    package = mypy-protobuf;
    command = "${lib.getExe mypy-protobuf} --version";
  };

  meta = {
    changelog = "https://github.com/nipunn1313/mypy-protobuf/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/nipunn1313/mypy-protobuf";
    license = lib.licenses.asl20;
    mainProgram = "protoc-gen-mypy";
    maintainers = with lib.maintainers; [ lnl7 ];
  };
})
