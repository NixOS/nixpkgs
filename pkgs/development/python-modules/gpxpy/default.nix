{ lib, fetchFromGitHub, buildPythonPackage, python, lxml, pythonOlder }:

buildPythonPackage rec {
  pname = "gpxpy";
  version = "1.5.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tkrajina";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Fkl2dte1WkPi2hBOdT23BMfNflR0j4GeNH86d46WNQk=";
  };

  propagatedBuildInputs = [ lxml ];

  checkPhase = ''
    ${python.interpreter} -m unittest test
  '';

  meta = with lib; {
    description = "Python GPX (GPS eXchange format) parser";
    homepage = "https://github.com/tkrajina/gpxpy";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
