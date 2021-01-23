{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, attrs
, audio-metadata
, importlib-metadata
, marshmallow
, pendulum
, protobuf
}:

buildPythonPackage rec {
  pname = "google-music-proto";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91b78c0de4f59b1e5503fd6d49cb3fec029d9199cca0794c87667e643342e987";
  };

  postPatch = ''
    sed -i -e "/audio-metadata/c\'audio-metadata'," -e "/marshmallow/c\'marshmallow'," setup.py
    substituteInPlace setup.py \
      --replace "'attrs>=18.2,<19.4'" "'attrs'"
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
