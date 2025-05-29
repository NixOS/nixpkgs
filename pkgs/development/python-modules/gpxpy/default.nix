{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  lxml,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gpxpy";
  version = "1.6.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tkrajina";
    repo = "gpxpy";
    rev = "v${version}";
    hash = "sha256-s65k0u4LIwHX9RJMJIYMkNS4/Z0wstzqYVPAjydo2iI=";
  };

  propagatedBuildInputs = [ lxml ];

  checkPhase = ''
    ${python.interpreter} -m unittest test
  '';

  meta = with lib; {
    description = "Python GPX (GPS eXchange format) parser";
    mainProgram = "gpxinfo";
    homepage = "https://github.com/tkrajina/gpxpy";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
