{ stdenv
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
  version = "2.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c24156a3d6887b641ceb37b57d91805bee6c3352e8a3ca97a3274217ead9294";
  };

  propagatedBuildInputs = [ botocore boto3 docutils ];
  buildInputs = [ unittest2 mock ];

  meta = with stdenv.lib; {
    description = "Python library to make retrieving Amazon VPC Flow Logs from CloudWatch Logs a bit easier";
    homepage = "https://github.com/obsrvbl/flowlogs-reader";
    maintainers = with maintainers; [ cransom ];
    license = licenses.asl20;
  };

}
