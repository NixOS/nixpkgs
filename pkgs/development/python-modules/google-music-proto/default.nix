{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, audio-metadata
, marshmallow
, pendulum
, protobuf
}:

buildPythonPackage rec {
  pname = "google-music-proto";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "008nap32hcrlnkkqkf462vwnm6xzrn6fj71lbryfmrakad7rz7bc";
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
