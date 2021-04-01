{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytube";
  version = "10.6.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pytube";
    repo = "pytube";
    rev = "v${version}";
    sha256 = "sha256-b0tN4m3/+K243zQ7L4wW4crk9r69Tj64is6C4I5oFZU=";
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
