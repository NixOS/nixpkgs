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
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f23d5cb7d862b104401d9021fc82e5fa0e0cf57b7660a1331425aab0c691d021";
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
