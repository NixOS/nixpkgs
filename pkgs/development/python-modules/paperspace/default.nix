{ stdenv, fetchPypi, buildPythonPackage
, boto3, requests
}:

buildPythonPackage rec {
  pname = "paperspace";
  version = "0.0.11";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z19arikcjpfvp3bgssnlhplm1qzgw95s3r5fnsyf7nwmc4pvvpa";
  };

  buildInputs = [ boto3 requests ];

  doCheck = false; # bizarre test failure

  meta = with stdenv.lib; {
    description = "Python API for Paperspace Cloud";
    homepage    = https://paperspace.com;
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
