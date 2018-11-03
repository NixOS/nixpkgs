{ stdenv
, buildPythonPackage
, fetchurl
}:

buildPythonPackage rec {
  pname = "gdata";
  version = "2.0.18";

  src = fetchurl {
    url = "https://gdata-python-client.googlecode.com/files/${pname}-${version}.tar.gz";
    sha256 = "1dpxl5hwyyqd71avpm5vkvw8fhlvf9liizmhrq9jphhrx0nx5rsn";
  };

  # Fails with "error: invalid command 'test'"
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/gdata-python-client/;
    description = "Python client library for Google data APIs";
    license = licenses.asl20;
  };

}
