{ lib
, buildPythonPackage
, fetchPypi
, coverage
, ddt
, nose
, pyyaml
, requests
, testtools
}:

buildPythonPackage rec {
  pname = "falcon";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xB2E2zJYgahw6LcSnV7P2XL6QyPPd7cRmh0qIZZu5oE=";
  };

  checkInputs = [coverage ddt nose pyyaml requests testtools];

  # The travis build fails since the migration from multiprocessing to threading for hosting the API under test.
  # OSError: [Errno 98] Address already in use
  doCheck = false;

  meta = with lib; {
    description = "An unladen web framework for building APIs and app backends";
    homepage = "https://falconframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };

}
