{ stdenv
, buildPythonPackage
, fetchPypi
, botocore
, boto3
, docutils
, unittest2
, mock
}:

buildPythonPackage rec {
  pname = "flowlogs_reader";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd6344fdad097c38756772624922ee37452ef1e131213c7d0b5702bcf52a5b02";
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
