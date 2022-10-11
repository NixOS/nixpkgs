{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynobo";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "echoromeo";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-msJClYHljib8sATooI8q4irz6cC8hEgvcxLmmgatvwU=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pynobo"
  ];

  meta = with lib; {
    description = "Python TCP/IP interface for Nobo Hub/Nobo Energy Control devices";
    homepage = "https://github.com/echoromeo/pynobo";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
