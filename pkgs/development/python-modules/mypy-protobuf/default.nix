{ stdenv, fetchPypi, buildPythonApplication, protobuf }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bmpd82qm7rjnzc4i275lm18mmz8anhrjhwq2ci179l64hrfr0nb";
  };

  propagatedBuildInputs = [ protobuf ];

  meta = with stdenv.lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
