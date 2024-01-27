{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "dlx";
  version = "1.0.4";
  format = "setuptools";

  # untagged releases
  src = fetchFromGitHub {
    owner = "sraaphorst";
    repo = "dlx_python";
    rev = "02d1ed534df60513095633da07e67a6593b9e9b4";
    sha256 = "0c6dblbypwmx6yrk9qxp157m3cd7lq3j411ifr3shscv1igxv5hk";
  };

  # No test suite, so just run an example
  pythonImportsCheck = [ "dlx" ];
  # ./examples/design.py requires pyncomb, not in tree
  checkPhase = ''
    # example sudoku board from ./examples/sudoku.py
    ${python.interpreter} ./examples/sudoku.py 3 "070285010008903500000000000500010008010000090900040003000000000002408600090632080"
  '';

  meta = with lib; {
    description = "Implementation of Donald Knuth's Dancing Links algorithm";
    homepage = "https://github.com/sraaphorst/dlx_python";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
