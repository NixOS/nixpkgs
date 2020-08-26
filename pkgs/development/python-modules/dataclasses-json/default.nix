{ lib
, buildPythonPackage
, fetchPypi
, stringcase
, typing-inspect
, marshmallow-enum
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56ec931959ede74b5dedf65cf20772e6a79764d20c404794cce0111c88c085ff";
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
