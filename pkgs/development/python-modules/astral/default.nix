{ lib, buildPythonPackage, fetchPypi, isPy27, pytz, requests, pytest, freezegun }:

buildPythonPackage rec {
  pname = "astral";
  version = "3.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-m3w7QS6eadFyz7JL4Oat3MnxvQGijbi+vmbXXMxTPYg=";
  };

  propagatedBuildInputs = [ pytz requests freezegun ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test -m "not webtest"
  '';

  meta = with lib; {
    description = "Calculations for the position of the sun and the moon";
    homepage = "https://github.com/sffjunkie/astral/";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
