{ lib
, fetchPypi
, buildPythonPackage
, protobuf
, types-protobuf
, grpcio-tools
, pytestCheckHook
, pythonOlder
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
    protobuf
    types-protobuf
    grpcio-tools
  ];

  doCheck = false; # ModuleNotFoundError: No module named 'testproto'

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mypy_protobuf"
  ];

  meta = with lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
