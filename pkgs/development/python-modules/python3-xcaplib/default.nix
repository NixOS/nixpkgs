{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, gevent
, lxml
, python3-application
, python3-eventlib
, twisted
}:

buildPythonPackage rec {
  pname = "python3-xcaplib";
  version = "2.0.1";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = version;
    sha256 = "sha256-tIHDkseFkLqrdXFPSemYfOMRRhNcqJxCgMSr2xkI/DA=";
  };

  propagatedBuildInputs = [
    gevent
    lxml
    python3-application
    python3-eventlib
    twisted
  ];

  pythonImportsCheck = [ "xcaplib" ];

  meta = with lib; {
    description = "XCAP (RFC4825) client library";
    homepage = "https://github.com/AGProjects/python3-xcaplib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ yureien ];
  };
}
