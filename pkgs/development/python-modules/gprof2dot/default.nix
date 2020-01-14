{ lib, fetchFromGitHub, buildPythonApplication, python, graphviz }:

buildPythonApplication {
  name = "gprof2dot-2019-11-30";

  src = fetchFromGitHub {
    owner = "jrfonseca";
    repo = "gprof2dot";
    rev = "2019.11.30";
    sha256 = "1nw4cfwimd0djarw4wc756q095xir78js8flmycg6g7sl3l6p27s";
  };

  checkInputs = [ graphviz ];
  checkPhase = "${python.interpreter} tests/test.py";

  meta = with lib; {
    homepage = "https://github.com/jrfonseca/gprof2dot";
    description = "Python script to convert the output from many profilers into a dot graph";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.pmiddend ];
  };
}
