{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pynobo";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "echoromeo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7OWCp09XxCZJMz0BJWKfGkkl8z4XpRS2sjowp/bnl0A=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynobo" ];

  meta = with lib; {
    description = "Python 3 TCP/IP interface for Nobo Hub/Nobo Energy Control devices";
    homepage = "https://github.com/echoromeo/pynobo";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
