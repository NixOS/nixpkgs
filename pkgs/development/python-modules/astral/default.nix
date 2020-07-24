{ stdenv, buildPythonPackage, fetchPypi, isPy27, pytz, requests, pytest, freezegun }:

buildPythonPackage rec {
  pname = "astral";
  version = "2.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e41d9967d5c48be421346552f0f4dedad43ff39a83574f5ff2ad32b6627b6fbe";
  };

  propagatedBuildInputs = [ pytz requests freezegun ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test -m "not webtest"
  '';

  meta = with stdenv.lib; {
    description = "Calculations for the position of the sun and the moon";
    homepage = "https://github.com/sffjunkie/astral/";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
