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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eea593cf466b9c126ce667f6d30503624ef24459f118c75594a69353b6c3d5fc";
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
