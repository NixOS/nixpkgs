{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "chess";
  version = "1.6.1";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "sha256-2pyABmr6q1Y2/ivtvMYqRHE2Zjlyz2QO0us0w4l2HQM=";
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
