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
    sha256 = "c41d84db325881a870e8b7129d5ecfd972fa4323cf77b7119a1d2a21966ee681";
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
