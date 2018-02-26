{ stdenv, buildPythonPackage, fetchPypi, pytz, pytest }:

buildPythonPackage rec {
  pname = "astral";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "874b397ddbf0a4c1d8d644b21c2481e8a96b61343f820ad52d8a322d61a15083";
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
