{ lib
, buildPythonPackage
, fetchPypi
, botocore
, jmespath
, s3transfer
, futures ? null
, docutils
, nose
, mock
, isPy3k
}:

buildPythonPackage rec {
  pname = "boto3";
  version = "1.24.42"; # N.B: if you change this, change botocore and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3z1u8CMEvXw3EQkJNsCS1dtzXdoQneysHiNsPvf9t68=";
  };

  propagatedBuildInputs = [ botocore jmespath s3transfer ] ++ lib.optionals (!isPy3k) [ futures ];
  checkInputs = [ docutils nose mock ];

  checkPhase = ''
    runHook preCheck
    # This method is not in mock. It might have appeared in some versions.
    sed -i 's/action.assert_called_once()/self.assertEqual(action.call_count, 1)/' \
      tests/unit/resources/test_factory.py
    nosetests -d tests/unit --verbose
    runHook postCheck
  '';

  # Network access
  doCheck = false;

  pythonImportsCheck = [ "boto3" ];

  meta = {
    homepage = "https://github.com/boto/boto3";
    license = lib.licenses.asl20;
    description = "AWS SDK for Python";
    longDescription = ''
      Boto3 is the Amazon Web Services (AWS) Software Development Kit (SDK) for
      Python, which allows Python developers to write software that makes use of
      services like Amazon S3 and Amazon EC2.
    '';
  };
}
