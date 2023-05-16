<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, fixtures
, purl
, pytestCheckHook
, python
, requests
, requests-futures
, six
, testtools
=======
{ lib, buildPythonPackage, fetchPypi, python
, mock
, purl
, requests
, six
, testrepository
, testtools
, pytest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "requests-mock";
<<<<<<< HEAD
  version = "1.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7xC1crSJpfKOCbcIaXIIxKOyuJ74Cp8BWENA6jV+w8Q=";
  };

  propagatedBuildInputs = [ requests six ];

  nativeCheckInputs = [
    fixtures
    purl
    pytestCheckHook
    requests-futures
    testtools
  ];
=======
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WcnDJBmp+xroPsJC2Y6InEW9fXpl1IN1zCQ+wIRBZYs=";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  propagatedBuildInputs = [ requests six ];

  nativeCheckInputs = [ mock purl testrepository testtools pytest ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Mock out responses from the requests package";
    homepage = "https://requests-mock.readthedocs.io";
<<<<<<< HEAD
    changelog = "https://github.com/jamielennox/requests-mock/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = [ ];
  };
}
