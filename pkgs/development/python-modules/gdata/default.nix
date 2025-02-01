{
  lib,
  buildPythonPackage,
  fetchurl,
}:

buildPythonPackage rec {
  pname = "gdata";
  version = "2.0.18";
  format = "setuptools";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/gdata-python-client/${pname}-${version}.tar.gz";
    sha256 = "1dpxl5hwyyqd71avpm5vkvw8fhlvf9liizmhrq9jphhrx0nx5rsn";
  };

  # Fails with "error: invalid command 'test'"
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/google/gdata-python-client";
    description = "Python client library for Google data APIs";
    license = licenses.asl20;
  };
}
