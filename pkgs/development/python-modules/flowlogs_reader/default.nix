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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0158aki6m3pkf98hpd60088qyhrfxkmybdf8hv3qfl8nb61vaiwf";
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
