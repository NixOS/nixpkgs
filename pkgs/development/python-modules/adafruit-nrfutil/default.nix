{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pyserial
, click
, ecdsa
, behave
, nose
}:

buildPythonPackage rec {
  pname = "adafruit-nrfutil";
  version = "0.5.3.post17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "Adafruit_nRF52_nrfutil";
    rev = version;
    sha256 = "sha256-mHHKOQE9AGBX8RAyaPOy+JS3fTs98+AFdq9qsVy7go4=";
  };

  patches = [
    # Pull a patch which fixes the tests, but is not yet released in a new version:
    # https://github.com/adafruit/Adafruit_nRF52_nrfutil/pull/38
    (fetchpatch {
      name = "fix-tests.patch";
      url = "https://github.com/adafruit/Adafruit_nRF52_nrfutil/commit/e5fbcc8ee5958041db38c04139ba686bf7d1b845.patch";
      sha256 = "sha256-0tbJldGtYcDdUzA3wZRv0lenXVn6dqV016U9nMpQ6/w=";
    })
  ];

  propagatedBuildInputs = [
    pyserial
    click
    ecdsa
  ];

  checkInputs = [
    behave
    nose
  ];

  preCheck = ''
    mkdir test-reports
  '';

  pythonImportsCheck = [
    "nordicsemi"
  ];

  meta = with lib; {
    homepage = "https://github.com/adafruit/Adafruit_nRF52_nrfutil";
    description = "Modified version of Nordic's nrfutil 0.5.x for use with the Adafruit Feather nRF52";
    license = licenses.bsd3;
    maintainers = with maintainers; [ stargate01 ];
  };
}
