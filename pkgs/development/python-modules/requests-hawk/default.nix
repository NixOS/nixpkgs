{ lib, buildPythonPackage, fetchPypi, python, mohawk, requests }:

buildPythonPackage rec {
  pname = "requests-hawk";
<<<<<<< HEAD
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rZIFBCyUvbFa+qGbB4DhEHeyTZ5c/6wfs9JssIqkNbc=";
=======
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c74bd31b581f6d2b36d575bb537b1f29469509f560f5050339a48195d48929b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ mohawk requests ];

  meta = with lib; {
    description = "Hawk authentication strategy for the requests python library.";
    homepage = "https://github.com/mozilla-services/requests-hawk";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
