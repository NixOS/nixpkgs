{ lib, fetchPypi, buildPythonApplication, protobuf, types-protobuf, grpcio-tools, pythonOlder }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "2.10";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fed214e16351b09946770794a321a818abb744078b1d863a479da070028684c";
  };

  propagatedBuildInputs = [ protobuf types-protobuf grpcio-tools ];

  meta = with lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
