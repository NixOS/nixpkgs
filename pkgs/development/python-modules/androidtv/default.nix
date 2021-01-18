{ aiofiles, adb-shell, buildPythonPackage, fetchFromGitHub, isPy3k, lib, mock
, pure-python-adb, python }:

buildPythonPackage rec {
  pname = "androidtv";
  version = "0.0.50";

  # pypi does not contain tests, using github sources instead
  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "python-androidtv";
    rev = "v${version}";
    sha256 = "1iqw40szwgzvhv3fbnx2wwfnw0d3clcwk9vsq1xsn30fjil2vl7b";
  };

  propagatedBuildInputs = [ adb-shell pure-python-adb ]
    ++ lib.optionals (isPy3k) [ aiofiles ];

  checkInputs = [ mock ];
  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests -t .
  '';

  meta = with lib; {
    description =
      "Communicate with an Android TV or Fire TV device via ADB over a network.";
    homepage = "https://github.com/JeffLIrion/python-androidtv/";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
