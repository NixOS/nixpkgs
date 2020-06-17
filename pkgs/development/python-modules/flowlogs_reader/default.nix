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
  version = "2.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "256c67afabc1783e8a378c7589877f76660c6a645aa6dfe1759e26f4a93a22d0";
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
