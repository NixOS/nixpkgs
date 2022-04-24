{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "python-trovo";
  version = "0.1.5";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JUJax9nk4NqpMMrbDmQhcy22GIqPha+K4tudQ98PvlE=";
  };

  propagatedBuildInputs = [ requests ];

  # No tests found
  doCheck = false;

  pythonImportsCheck = [ "trovoApi" ];

  meta = with lib; {
    description = "A Python wrapper for the Trovo API";
    homepage = "https://codeberg.org/wolfangaukang/python-trovo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
