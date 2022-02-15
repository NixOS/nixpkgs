{ lib, fetchPypi, buildPythonApplication, protobuf, types-protobuf, grpcio-tools, pythonOlder }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "3.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cwqhUzfDjwRG++CPbGwjcO4B05USU2nUtw4IseLuMO4=";
  };

  propagatedBuildInputs = [ protobuf types-protobuf grpcio-tools ];

  meta = with lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
