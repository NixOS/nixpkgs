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
  version = "2.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e47637b40a068a0c814ba2087fb691b43aa12e6174ab06b6cdb7109bb94624e4";
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
