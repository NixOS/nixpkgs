{ lib
, python
, fetchFromGitHub
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "icnsutil";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "relikd";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tiq8h6s2noWLBIOIWcj8jfSqJFN01ee2uoHN4aFwn7s=";
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
