{ lib
, buildPythonPackage
, fetchPypi
, nose
, pygments
, isPy3k
}:

buildPythonPackage rec {
  version = "0.10.0";
  format = "setuptools";
  pname = "piep";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aM7KQJZr1P0Hs2ReyRj2ItGUo+fRJ+TU3lLAU2Mu8KA=";
  };

  propagatedBuildInputs = [ pygments ];
  nativeCheckInputs = [ nose ];

  meta = with lib; {
    description = "Bringing the power of python to stream editing";
    homepage = "https://github.com/timbertson/piep";
    maintainers = with maintainers; [ timbertson ];
    license = licenses.gpl3;
  };

}
