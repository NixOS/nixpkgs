{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, google-cloud-storage
, mock
, pytestCheckHook
, pythonOlder
, smart-open
, typer
}:

buildPythonPackage rec {
  pname = "pathy";
<<<<<<< HEAD
  version = "0.10.2";
=======
  version = "0.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ecVyq3/thNxGg3NG7a5YVlmS0Ed6eJzUaRpB2Oq5kX0=";
=======
    hash = "sha256-TNbnG0zV/4dc+7lJrZ+lUZ2NHb5p1fwdGyOqPLBJYYs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    google-cloud-storage
    smart-open
    typer
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Exclude tests that require provider credentials
    "pathy/_tests/test_clients.py"
    "pathy/_tests/test_gcs.py"
    "pathy/_tests/test_s3.py"
  ];

  pythonImportsCheck = [
    "pathy"
  ];

  meta = with lib; {
    description = "A Path interface for local and cloud bucket storage";
    homepage = "https://github.com/justindujardin/pathy";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
