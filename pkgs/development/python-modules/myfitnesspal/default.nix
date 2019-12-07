{ lib, fetchPypi, buildPythonPackage
, blessed, keyring, keyrings-alt, lxml, measurement, python-dateutil, requests, six
, mock, nose }:

buildPythonPackage rec {
  pname = "myfitnesspal";
  version = "1.13.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "552cc696e170f12f75fd12b1447be01fa2d0bfd85e14da5928afd9aab2277b98";
  };

  # Remove overly restrictive version constraints on keyring and keyrings.alt
  postPatch = ''
    sed -i 's/keyring>=.*/keyring/' requirements.txt
    sed -i 's/keyrings.alt>=.*/keyrings.alt/' requirements.txt
  '';

  checkInputs = [ mock nose ];
  propagatedBuildInputs = [ blessed keyring keyrings-alt lxml measurement python-dateutil requests six ];

  meta = with lib; {
    description = "Access your meal tracking data stored in MyFitnessPal programatically";
    homepage = https://github.com/coddingtonbear/python-myfitnesspal;
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
