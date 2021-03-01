{ lib
, buildPythonPackage
, fetchPypi
, python
, rply
}:

buildPythonPackage rec {
  pname = "rnc2rng";
  version = "2.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kmp3iwxxyzjsd47j2sprd47ihhkwhb3yydih3af5bbfq0ibh1w8";
  };

  propagatedBuildInputs = [ rply ];

  checkPhase = "${python.interpreter} test.py";

  meta = with lib; {
    homepage = "https://github.com/djc/rnc2rng";
    description = "Compact to regular syntax conversion library for RELAX NG schemata";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
