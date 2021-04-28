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
, futures ? null
}:

buildPythonPackage rec {
  pname = "s3transfer";
  version = "0.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5dadf598762899d8cfaecf68eba649cd25b0ce93b6c954b156aaa3eed160547";
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
