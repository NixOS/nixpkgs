{ stdenv, buildPythonPackage, fetchPypi, pytz, requests, pytest }:

buildPythonPackage rec {
  pname = "astral";
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j4rzmm0im8997c7b64kfq099531qcxp6xzh0dhyb4f5176lqqkx";
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
