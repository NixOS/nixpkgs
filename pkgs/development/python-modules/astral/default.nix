{ stdenv, buildPythonPackage, fetchPypi, pytz, requests, pytest }:

buildPythonPackage rec {
  pname = "astral";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "874b397ddbf0a4c1d8d644b21c2481e8a96b61343f820ad52d8a322d61a15083";
  };

  propagatedBuildInputs = [ pytz requests ];

  checkInputs = [ pytest ];
  checkPhase = ''
    # https://github.com/sffjunkie/astral/pull/13
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
