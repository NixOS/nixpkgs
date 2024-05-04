{
  buildPythonPackage,
  fetchPypi,
  grpcio-tools,
  lib,
  protobuf,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  types-protobuf,
}:

buildPythonPackage rec {
  pname = "mypy-protobuf";
  version = "3.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AvJC6zQJ9miJ8rGjqlg1bsTZCc3Q+TEVYi6ecDZuyjw=";
  };

  propagatedBuildInputs = [
    grpcio-tools
    protobuf
    types-protobuf
  ];

  doCheck = false; # ModuleNotFoundError: No module named 'testproto'

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mypy_protobuf" ];

  meta = {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/nipunn1313/mypy-protobuf";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lnl7 ];
  };
}
