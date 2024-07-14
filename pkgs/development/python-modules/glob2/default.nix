{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  pname = "glob2";
  version = "0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hcPb0HyKom1j16rO40+obpqRo4c7wwv2LsRuUx+Sq4w=";
  };

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with lib; {
    description = "Version of the glob module that can capture patterns and supports recursive wildcards";
    homepage = "https://github.com/miracle2k/python-glob2/";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
