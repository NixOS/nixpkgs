{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytube";
  version = "10.8.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pytube";
    repo = "pytube";
    rev = "v${version}";
    sha256 = "sha256-LY1aDFzF0vHwEa3pfAoxZ3KM1l39PDo6S6F3xtqqspU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytube" ];

  meta = with lib; {
    description = "Python 3 library for downloading YouTube Videos";
    homepage = "https://github.com/nficano/pytube";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
