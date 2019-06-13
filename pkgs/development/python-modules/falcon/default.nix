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
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3981f609c0358a9fcdb25b0e7fab3d9e23019356fb429c635ce4133135ae1bc4";
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
