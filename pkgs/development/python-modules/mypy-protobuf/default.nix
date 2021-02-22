{ lib, fetchPypi, buildPythonApplication, protobuf }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "1.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf79c77e828a2de9bdc74b43ad4abd4c2a3a30f0471b46e9b4e01b9877f166fb";
  };

  propagatedBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
