{ stdenv, fetchPypi, buildPythonApplication, protobuf }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "1.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0eb8db49b014d1082f370a39eeaf272d1cc9978f728b64ee6fcc822d00a8793c";
  };

  propagatedBuildInputs = [ protobuf ];

  meta = with stdenv.lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
