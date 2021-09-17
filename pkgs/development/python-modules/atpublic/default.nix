{ lib, isPy3k, pythonOlder, fetchPypi, buildPythonPackage
, pytest
, pytest-cov
, sybil
, typing-extensions
}:

buildPythonPackage rec {
  pname = "atpublic";
  version = "2.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6b9167fc3e09a2de2d2adcfc9a1b48d84eab70753c97de3800362e1703e3367";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytest pytest-cov sybil
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
