{ stdenv, fetchPypi, buildPythonApplication, protobuf }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "1.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03j2i9vhpdxbvwlqg6zghlzzq46s1x2jbx20fwninb6kss0ps3rg";
  };

  propagatedBuildInputs = [ protobuf ];

  meta = with stdenv.lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
