{ stdenv, buildPythonPackage, fetchPypi, pytz, pytest }:

buildPythonPackage rec {
  pname = "astral";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "527628fbfe90c1596c3950ff84ebd07ecc10c8fb1044c903a0519b5057700cb6";
  };

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test -k "not test_GoogleLocator"
  '';

  meta = with stdenv.lib; {
    description = "Calculations for the position of the sun and the moon";
    homepage = https://github.com/sffjunkie/astral/;
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
