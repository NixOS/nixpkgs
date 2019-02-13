{ stdenv, fetchPypi, buildPythonApplication, protobuf }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00b030f9558454ec237576def2de9b7e50517ae039e03d84482b6ddf1bd1d54d";
  };

  propagatedBuildInputs = [ protobuf ];

  meta = with stdenv.lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
