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
  version = "2.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "19118ff77925c66a6782152066d86bc8d5c6ed60189b642263fb0c6eb7cb22ef";
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
