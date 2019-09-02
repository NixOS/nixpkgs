{ stdenv, fetchPypi, buildPythonApplication, protobuf }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be1f14b0b841b49adb2f6018eaa1ce9529c8147eb561909baaa757e8cf9e821b";
  };

  propagatedBuildInputs = [ protobuf ];

  meta = with stdenv.lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
