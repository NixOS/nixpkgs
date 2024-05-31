{
  buildPythonPackage,
  fetchPypi,
  grpcio-tools,
  lib,
  mypy-protobuf,
  protobuf,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  setuptools,
  testers,
  types-protobuf,
}:

buildPythonPackage rec {
  pname = "mypy-protobuf";
  version = "3.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AvJC6zQJ9miJ8rGjqlg1bsTZCc3Q+TEVYi6ecDZuyjw=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

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
    changelog = "https://github.com/nipunn1313/mypy-protobuf/blob/v${version}/CHANGELOG.md";
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/nipunn1313/mypy-protobuf";
    license = lib.licenses.asl20;
    mainProgram = "protoc-gen-mypy";
    maintainers = with lib.maintainers; [ lnl7 ];
  };
}
