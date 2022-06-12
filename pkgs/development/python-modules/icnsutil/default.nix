{ lib
, python
, fetchFromGitHub
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "icnsutil";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "relikd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TfQvAbP7iCpRQg2G+ejl245NCYo9DpYwMgiwY2BuJnY=";
  };

  doCheck = true;

  checkPhase = ''
    ${python.interpreter} tests/test_icnsutil.py
    ${python.interpreter} tests/test_cli.py
  '';

  meta = {
    homepage = "https://github.com/relikd/icnsutil";
    description = "Create and extract .icns files.";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.reckenrode ];
  };
}
