{ lib, fetchPypi, buildPythonPackage
, blessed, keyring, keyrings-alt, lxml, measurement, python-dateutil, requests, six
, mock, nose }:

buildPythonPackage rec {
  pname = "myfitnesspal";
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "66bf61c3d782cd80f380d3856da5f635f5b8de032e62d916c26d48dc322846a6";
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
    homepage = "https://github.com/coddingtonbear/python-myfitnesspal";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
