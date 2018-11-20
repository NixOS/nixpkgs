{ stdenv, fetchPypi, buildPythonPackage
, boto3, requests
}:

buildPythonPackage rec {
  pname = "paperspace";
  version = "0.0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e7192ee9270768c0dba44969d49730c17d2f955c201798706cdcbc407310d64";
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
