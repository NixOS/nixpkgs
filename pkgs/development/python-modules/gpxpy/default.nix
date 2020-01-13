{ lib, fetchFromGitHub, buildPythonPackage, python, lxml }:

buildPythonPackage rec {
  pname = "gpxpy";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "tkrajina";
    repo = pname;
    rev = "v${version}";
    sha256 = "18r7pfda7g3l0hv8j9565n52cvvgjxiiqqzagfdfaba1djgl6p8b";
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
