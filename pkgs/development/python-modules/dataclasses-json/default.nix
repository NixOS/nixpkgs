{ lib
, buildPythonPackage
, fetchPypi
, stringcase
, typing-inspect
, marshmallow-enum
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/hfak0z8TseS6+fpowNDTs9PX42KdwWs+758y9NL8a4=";
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
    maintainers = with maintainers; [ albakham sumnerevans ];
  };
}
