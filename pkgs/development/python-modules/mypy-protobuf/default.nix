{ lib, fetchPypi, buildPythonApplication, protobuf, types-protobuf, grpcio-tools, pythonOlder }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "3.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "558dcc390290e43c7def0d4238cc41a79abde06ff509b3014c3dff0553c7b0c1";
  };

  propagatedBuildInputs = [ protobuf types-protobuf grpcio-tools ];

  meta = with lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
