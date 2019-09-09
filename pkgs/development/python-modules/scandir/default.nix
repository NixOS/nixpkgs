{ lib, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "scandir";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 ="1bkqwmf056pkchf05ywbnf659wqlp6lljcdb0y88wr9f0vv32ijd";
  };

  checkPhase = "${python.interpreter} test/run_tests.py";

  meta = with lib; {
    description = "A better directory iterator and faster os.walk()";
    homepage = https://github.com/benhoyt/scandir;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
