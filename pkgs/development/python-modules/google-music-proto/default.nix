{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, audio-metadata
, marshmallow
, pendulum
, protobuf
}:

buildPythonPackage rec {
  pname = "google-music-proto";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "94cd205b3cb0d9e36f3724ace259d4c6de04db97e095577a26a5cfa5e35844c6";
  };

  propagatedBuildInputs = [
    attrs
    audio-metadata
    marshmallow
    pendulum
    protobuf
  ];

  # No tests
  doCheck = false;

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = https://github.com/thebigmunch/google-music-proto;
    description = "Sans-I/O wrapper of Google Music API calls";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
