{ lib
, buildPythonPackage
, fetchFromGitHub
, stringcase
, typing-inspect
, marshmallow-enum
, python3Packages
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "lidatong";
    repo = "dataclasses-json";
    rev = "v${version}";
    sha256 = "sha256-4Jh79aoGQzgjBqHiWrmeyIlU+jPnsBgvdpwyh5tAd4I=";
  };

  propagatedBuildInputs = [
    stringcase
    typing-inspect
    marshmallow-enum
  ];

  checkInputs = with python3Packages; [
    hypothesis
    mypy
    pytest
  ];
  # Ignoring the tests/test_annotations test because it fails due to not being
  # able to find a library stub for 'mypy.main'.
  checkPhase = "pytest --ignore tests/test_annotations.py";

  meta = with lib; {
    description = "Simple API for encoding and decoding dataclasses to and from JSON";
    homepage = "https://github.com/lidatong/dataclasses-json";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham sumnerevans ];
  };
}
