{ lib, fetchPypi, buildPythonApplication, protobuf, pythonOlder }:

buildPythonApplication rec {
  pname = "mypy-protobuf";
  version = "2.4";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77e10c476cdd3ee14535c2357e64deac6b1a69f33eb500d795b064acda48c66f";
  };

  propagatedBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "Generate mypy stub files from protobuf specs";
    homepage = "https://github.com/dropbox/mypy-protobuf";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
