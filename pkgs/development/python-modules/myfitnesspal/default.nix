{ lib, fetchPypi, buildPythonPackage
, blessed, keyring, keyrings-alt, lxml, measurement, python-dateutil, requests, six
, mock, nose }:

buildPythonPackage rec {
  pname = "myfitnesspal";
  version = "1.13.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f785341f0499bad8d3400cfcfffd99b7fcf8aac3971390f8ec3dfaed8361b20";
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
