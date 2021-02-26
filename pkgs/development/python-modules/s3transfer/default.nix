{ lib
, fetchPypi
, pythonOlder
, buildPythonPackage
, docutils
, mock
, nose
, coverage
, wheel
, unittest2
, botocore
, futures
}:

buildPythonPackage rec {
  pname = "s3transfer";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fdddb4f22275cf1d32129e21f056337fd2a80b6ccef1664528145b72c49e6d2";
  };

  propagatedBuildInputs =
    [ botocore
    ] ++ lib.optional (pythonOlder "3") futures;

  buildInputs = [
    docutils
    mock
    nose
    coverage
    wheel
    unittest2
  ];

  checkPhase = ''
    pushd s3transfer/tests
    nosetests -v unit/ functional/
    popd
  '';

  # version on pypi has no tests/ dir
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/boto/s3transfer";
    license = licenses.asl20;
    description = "A library for managing Amazon S3 transfers";
  };
}
