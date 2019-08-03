{ stdenv, fetchPypi, buildPythonPackage
, boto3, requests
}:

buildPythonPackage rec {
  pname = "paperspace";
  version = "0.0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2216fb31919595ba442077e8028cc05b0598421a74604daeae4d2baa5e8409d9";
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
