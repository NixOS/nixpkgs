{ stdenv
, buildPythonPackage
, fetchPypi
, coverage
, ddt
, nose
, pyyaml
, requests
, testtools
, six
, python_mimeparse
}:

buildPythonPackage rec {
  pname = "falcon";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ddce23a2dd0abba6d19775e9bf7ba64e184b15a0e7163e65f62af63354193f63";
  };

  checkInputs = [coverage ddt nose pyyaml requests testtools];
  propagatedBuildInputs = [ six python_mimeparse ];

  # The travis build fails since the migration from multiprocessing to threading for hosting the API under test.
  # OSError: [Errno 98] Address already in use
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An unladen web framework for building APIs and app backends";
    homepage = http://falconframework.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };

}
