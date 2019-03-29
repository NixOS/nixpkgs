{ stdenv, fetchPypi, buildPythonPackage
, boto3, requests
}:

buildPythonPackage rec {
  pname = "paperspace";
  version = "0.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af96dae7a1d84df8781aded392764953c9cbeb43d5cc314e405d3470f7c8006c";
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
