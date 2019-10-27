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
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6efc926738a3cd576c2a79725fed9afde92378aa5c6a957e3af010cb019fac9d";
  };

  outputs = [ "out" "dev" ];

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
