{ stdenv
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
  version = "0.1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07hjj1cy62sc3rh5lhna9mhylp7h7aak4v6mf6809q4nc8j1p28h";
  };

  foo = 1;

  propagatedBuildInputs =
    [ botocore
    ] ++ stdenv.lib.optional (pythonOlder "3") futures;

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

  meta = {
    homepage = https://github.com/boto/s3transfer;
    license = stdenv.lib.licenses.asl20;
    description = "A library for managing Amazon S3 transfers";
  };
}
