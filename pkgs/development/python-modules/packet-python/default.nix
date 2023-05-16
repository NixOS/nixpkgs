{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
, requests
=======
, requests
, python

# For tests/setup.py
, pytest
, pytest-runner
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests-mock
}:

buildPythonPackage rec {
  pname = "packet-python";
  version = "1.44.3";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WVfMELOoml7Hx78jy6TAwlFRLuSQu9dtsb6Khs6/cgI=";
  };
<<<<<<< HEAD

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "packet"
  ];

  meta = with lib; {
    description = "Python client for the Packet API";
    homepage = "https://github.com/packethost/packet-python";
    changelog = "https://github.com/packethost/packet-python/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ dipinhora ];
=======
  nativeBuildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ requests ];
  nativeCheckInputs = [
    pytest
    pytest-runner
    requests-mock
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = {
    description = "A Python client for the Packet API.";
    homepage    = "https://github.com/packethost/packet-python";
    license     = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ dipinhora ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
