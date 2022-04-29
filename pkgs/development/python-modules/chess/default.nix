{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "chess";
  version = "1.9.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "sha256-2/6pHU4gJnnVdO2KyXBe/RAbnEIuc2AY+h4TO70qiRk=";
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
