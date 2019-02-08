{ stdenv, buildPythonPackage, fetchPypi, pytz, requests, pytest }:

buildPythonPackage rec {
  pname = "astral";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "179f72a086cee96487e60514bab81e821966953fc2e2f7091500d3d2c314e38b";
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
