{ lib, fetchPypi, buildPythonApplication, protobuf, types-protobuf, grpcio-tools, pythonOlder }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "2.9";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "278172935d7121c2f8c7c0a05518dd565a2b76d9e9c4a0a3fcd08a21fa685d43";
  };

  propagatedBuildInputs = [ protobuf types-protobuf grpcio-tools ];

  meta = with lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
