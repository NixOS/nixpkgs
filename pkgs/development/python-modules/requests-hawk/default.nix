{
  lib,
  buildPythonPackage,
  fetchPypi,
  mohawk,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-hawk";
  version = "1.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rZIFBCyUvbFa+qGbB4DhEHeyTZ5c/6wfs9JssIqkNbc=";
  };

  propagatedBuildInputs = [
    mohawk
    requests
  ];

<<<<<<< HEAD
  meta = {
    description = "Hawk authentication strategy for the requests python library";
    homepage = "https://github.com/mozilla-services/requests-hawk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ austinbutler ];
=======
  meta = with lib; {
    description = "Hawk authentication strategy for the requests python library";
    homepage = "https://github.com/mozilla-services/requests-hawk";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
