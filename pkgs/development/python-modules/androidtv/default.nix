{ lib
, adb-shell
, aiofiles
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, mock
, pure-python-adb
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "androidtv";
  version = "0.0.60";

  # pypi does not contain tests, using github sources instead
  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "python-androidtv";
    rev = "v${version}";
    sha256 = "sha256-GWCiRxZ6pHrcVkOKNGxSK8lUD0RohtED8czXIWUoVaM=";
  };

  propagatedBuildInputs = [ adb-shell pure-python-adb ]
    ++ lib.optionals (isPy3k) [ aiofiles ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "androidtv" ];

  meta = with lib; {
    description =
      "Communicate with an Android TV or Fire TV device via ADB over a network";
    homepage = "https://github.com/JeffLIrion/python-androidtv/";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
