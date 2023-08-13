{ lib, buildPythonPackage, fetchPypi, python, mohawk, requests }:

buildPythonPackage rec {
  pname = "requests-hawk";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rZIFBCyUvbFa+qGbB4DhEHeyTZ5c/6wfs9JssIqkNbc=";
  };

  propagatedBuildInputs = [ mohawk requests ];

  meta = with lib; {
    description = "Hawk authentication strategy for the requests python library.";
    homepage = "https://github.com/mozilla-services/requests-hawk";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
