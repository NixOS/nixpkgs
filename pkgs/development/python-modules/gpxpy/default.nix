{ lib, fetchFromGitHub, buildPythonPackage, python, lxml, isPy3k }:

buildPythonPackage rec {
  pname = "gpxpy";
  version = "1.4.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tkrajina";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r5gb660nrkrdbw5m5h1n5k10npcfv9bxqv92z55ds8r7rw2saz6";
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
