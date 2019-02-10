{ stdenv, fetchPypi, buildPythonPackage
, boto3, requests
}:

buildPythonPackage rec {
  pname = "paperspace";
  version = "0.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "824ec2aeccc6ddaba82a28b4ab74b1c81fb94206fd89c2b083eae3a61e63c2bf";
  };

  propagatedBuildInputs = [ boto3 requests ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python API for Paperspace Cloud";
    homepage    = https://paperspace.com;
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
