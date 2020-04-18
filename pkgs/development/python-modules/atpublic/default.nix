{ lib, isPy3k, fetchPypi, buildPythonPackage
, pytest }:

buildPythonPackage rec {
  pname = "atpublic";
  version = "1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i3sbxkdlbb4560rrlmwwd5y4ps7k73lp4d8wnmd7ag9k426gjkx";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest --pyargs public
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
