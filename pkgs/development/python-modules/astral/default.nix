{ stdenv, buildPythonPackage, fetchPypi, pytz, pytest }:

buildPythonPackage rec {
  pname = "astral";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1zm1ypc6w279gh7lbgsfbzfxk2x4gihlq3rfh59hj70hmhjwiwp7";
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
