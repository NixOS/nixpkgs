{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "chess";
  version = "1.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-jfPg1W9Qp0DlAbMXaFqZ6Ri2zMOW6EKUHwi7Azn/yl0=";
  };

  pythonImportsCheck = [
    "chess"
  ];

  checkPhase = ''
    ${python.interpreter} ./test.py -v
  '';

  meta = with lib; {
    description = "A chess library with move generation, move validation, and support for common formats";
    homepage = "https://github.com/niklasf/python-chess";
    changelog = "https://github.com/niklasf/python-chess/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ smancill ];
  };
}
