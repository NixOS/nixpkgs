{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytube";
  version = "10.9.3";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pytube";
    repo = "pytube";
    rev = "v${version}";
    sha256 = "sha256-x4u68O9dNhDZ+1Q+S4ou6zPqoR2/Yn5lcKgR2kyM/uo=";
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
