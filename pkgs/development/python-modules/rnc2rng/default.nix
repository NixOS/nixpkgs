{ lib
, buildPythonPackage
, fetchPypi
, python
, rply
}:

buildPythonPackage rec {
  pname = "rnc2rng";
  version = "2.6.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a01d157857b5f010a94167e7092cc49efe2531d58e013f12c4e60b8c4df78f1";
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
