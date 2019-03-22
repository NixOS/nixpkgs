{ stdenv, buildPythonPackage, fetchPypi, pytz, requests, pytest }:

buildPythonPackage rec {
  pname = "astral";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2a67243c4503131c856cafb1b1276de52a86e5b8a1d507b7e08bee51cb67bf1";
  };

  propagatedBuildInputs = [ pytz requests ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test -m "not webtest"
  '';

  meta = with stdenv.lib; {
    description = "Calculations for the position of the sun and the moon";
    homepage = https://github.com/sffjunkie/astral/;
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
