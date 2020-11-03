{ lib, isPy3k, pythonOlder, fetchPypi, buildPythonPackage
, pytest
, pytestcov
, sybil
, typing-extensions
}:

buildPythonPackage rec {
  pname = "atpublic";
  version = "2.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ebeb62b71a5c683a84c1b16bbf415708af5a46841b142b85ac3a22ec2d7613b0";
  };

  requiredPythonModules = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytest pytestcov sybil
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
