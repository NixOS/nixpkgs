{ lib
, buildPythonPackage
, fetchPypi
, stringcase
, typing-inspect
, marshmallow-enum
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nkgp4pd7j7ydrciiix4x0w56l5w6qvj2vgxpwj42h4f2wdv2f3f";
  };

  propagatedBuildInputs = [
    stringcase
    typing-inspect
    marshmallow-enum
  ];

  meta = with lib; {
    description = "Simple API for encoding and decoding dataclasses to and from JSON";
    homepage = "https://github.com/lidatong/dataclasses-json";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
  };
}
