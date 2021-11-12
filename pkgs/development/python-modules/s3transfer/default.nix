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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UO2CPh3FhorUDI3JIHL3V6oOZToZKEXJSjtnb0pi2kw=";
  };

  propagatedBuildInputs =
    [
      botocore
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
