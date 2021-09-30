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
    sha256 = "0gybxx4q9a5spf8hmvidgh51bisy08gf9dw9ldvmw3cfj4ix5h5m";
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
