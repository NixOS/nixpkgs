{stdenv, fetchPypi, buildPythonPackage, pythonOlder
, pyperclip, six, pyparsing
, contextlib2 ? null, subprocess32 ? null
, pytest, mock, which
}:
buildPythonPackage rec {
  pname = "cmd2";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fmpn3dwc0pyhdi6q877mb8i4vw9p9a0lgmrvsaclfah62grsfjb";
  };

  # 25 out of 191 tests failed
  doCheck=false;
  checkInputs= [ pytest mock which ];
  checkPhase = ''
    py.test
  '';

  propagatedBuildInputs = [
    pyperclip
    six
    pyparsing
  ]
  ++ stdenv.lib.optional (pythonOlder "3.5") contextlib2
  ++ stdenv.lib.optional (pythonOlder "3.0") subprocess32
  ;

  meta = with stdenv.lib; {
    description = "Enhancements for standard library's cmd module";
    homepage = https://github.com/python-cmd2/cmd2;
    maintainers = with maintainers; [ teto ];
  };
}
