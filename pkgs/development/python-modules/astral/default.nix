{ stdenv, buildPythonPackage, fetchPypi, pytz, requests, pytest }:

buildPythonPackage rec {
  pname = "astral";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab0c08f2467d35fcaeb7bad15274743d3ac1ad18b5391f64a0058a9cd192d37d";
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
