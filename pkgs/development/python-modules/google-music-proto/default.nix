{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, audio-metadata
, marshmallow
, pendulum
, protobuf
}:

buildPythonPackage rec {
  pname = "google-music-proto";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "798ac14408593525d1865f608b30f71cce291b1a239f4d63f14bb4dcf79d7528";
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
