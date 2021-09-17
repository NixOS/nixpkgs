{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, botocore
, boto3
, docutils
, unittest2
, mock
}:

buildPythonPackage rec {
  pname = "flowlogs_reader";
  version = "3.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d99636423abc83bb4042d63edd56852ede9e2949cadcc3339eda8f3367826dd4";
  };

  propagatedBuildInputs = [ botocore boto3 docutils ];
  buildInputs = [ unittest2 mock ];

  meta = with lib; {
    description = "Python library to make retrieving Amazon VPC Flow Logs from CloudWatch Logs a bit easier";
    homepage = "https://github.com/obsrvbl/flowlogs-reader";
    maintainers = with maintainers; [ cransom ];
    license = licenses.asl20;
  };

}
