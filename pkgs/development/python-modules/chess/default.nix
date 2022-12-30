{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "chess";
  version = "1.9.4";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-YBABB//53gwJIwrmKJh8W+05hTBhl+49vCYv9//4E+0=";
  };

  pythonImportsCheck = [ "chess" ];

  checkPhase = ''
    ${python.interpreter} ./test.py -v
  '';

  meta = with lib; {
    description = "A chess library for Python, with move generation, move validation, and support for common formats";
    homepage = "https://github.com/niklasf/python-chess";
    maintainers = with maintainers; [ smancill ];
    license = licenses.gpl3Plus;
  };
}
