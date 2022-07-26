{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pynobo";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "echoromeo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tcDSI5GODV53o4m35B4CXscVCnwt7gqRu7qohEnvyz8=";
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
