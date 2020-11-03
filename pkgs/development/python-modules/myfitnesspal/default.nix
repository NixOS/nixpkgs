{ lib, fetchPypi, buildPythonPackage
, blessed, keyring, keyrings-alt, lxml, measurement, python-dateutil, requests, six, rich
, pytestCheckHook, mock, nose }:

# TODO: Define this package in "all-packages.nix" using "toPythonApplication".
# This currently errors out, complaining about not being able to find "etree" from "lxml" even though "lxml" is defined in "propagatedBuildInputs".

buildPythonPackage rec {
  pname = "myfitnesspal";
  version = "1.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2275e91c794a3569a76c47c78cf2ff04d7f569a98558227e899ead7b30af0d6";
  };

  # Remove overly restrictive version constraints
  postPatch = ''
    sed -i 's/keyring>=.*/keyring/' requirements.txt
    sed -i 's/keyrings.alt>=.*/keyrings.alt/' requirements.txt
    sed -i 's/rich>=.*/rich/' requirements.txt
  '';

  propagatedBuildInputs = [ blessed keyring keyrings-alt lxml measurement python-dateutil requests six rich ];

  # Integration tests require an account to be set
  disabledTests = [ "test_integration" ];
  checkInputs = [ pytestCheckHook mock nose ];

  meta = with lib; {
    broken = true;
    description = "Access your meal tracking data stored in MyFitnessPal programatically";
    homepage = "https://github.com/coddingtonbear/python-myfitnesspal";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
