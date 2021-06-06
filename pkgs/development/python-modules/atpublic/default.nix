{ lib, isPy3k, pythonOlder, fetchPypi, buildPythonPackage
, pytest
, pytestcov
, sybil
, typing-extensions
}:

buildPythonPackage rec {
  pname = "atpublic";
  version = "2.1.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e0b274759bfbcb6eeb7c7b44a7a46391990a43ac77aa55359b075765b54d9f5d";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytest pytestcov sybil
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://public.readthedocs.io/en/latest/";
    description = "A decorator and function which populates a module's __all__ and globals";
    longDescription = ''
      This is a very simple decorator and function which populates a module's
      __all__ and optionally the module globals.

      This provides both a pure-Python implementation and a C implementation. It is
      proposed that the C implementation be added to builtins_ for Python 3.6.

      This proposal seems to have been rejected, for more information see
      https://bugs.python.org/issue26632.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
