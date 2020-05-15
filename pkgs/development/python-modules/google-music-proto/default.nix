{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, audio-metadata
, importlib-metadata
, marshmallow
, pendulum
, protobuf
}:

buildPythonPackage rec {
  pname = "google-music-proto";
  version = "2.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10qraipdr18pwnr1dz6ai5vxs9lmww5wbavbh1xyg4lsggmlsrqb";
  };

  postPatch = ''
    sed -i -e "/audio-metadata/c\'audio-metadata'," -e "/marshmallow/c\'marshmallow'," setup.py
  '';

  propagatedBuildInputs = [
    attrs
    audio-metadata
    marshmallow
    pendulum
    protobuf
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "google_music_proto" ];

  meta = with lib; {
    homepage = "https://github.com/thebigmunch/google-music-proto";
    description = "Sans-I/O wrapper of Google Music API calls";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
