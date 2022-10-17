{ lib, fetchPypi, buildPythonApplication, protobuf, types-protobuf, grpcio-tools, pythonOlder }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "3.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JPOwrssGZW6YP1jgfHMqkFd7nXrz4QZvwrZju/A3Akg=";
  };

  propagatedBuildInputs = [ protobuf types-protobuf grpcio-tools ];

  meta = with lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
