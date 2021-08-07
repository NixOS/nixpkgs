{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pynobo";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "echoromeo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f98qm9vp7f0hqaxhihv7y5swciyp60222la44f4936g0rvs005x";
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
