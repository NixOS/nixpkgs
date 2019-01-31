{ stdenv, buildPythonPackage, fetchPypi, pytz, requests, pytest }:

buildPythonPackage rec {
  pname = "astral";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5048d9cd57c746c7bcb6bb66274542d804c5a132ee5b88e9135d4e878221a119";
  };

  propagatedBuildInputs = [ pytz requests ];

  checkInputs = [ pytest ];
  checkPhase = ''
    # https://github.com/sffjunkie/astral/pull/26
    touch src/test/.api_key
    py.test -m "not webtest"
  '';

  meta = with stdenv.lib; {
    description = "Calculations for the position of the sun and the moon";
    homepage = https://github.com/sffjunkie/astral/;
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
