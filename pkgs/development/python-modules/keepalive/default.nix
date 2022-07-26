{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "keepalive";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c6b96f9062a5a76022f0c9d41e9ef5552d80b1cadd4fccc1bf8f183ba1d1ec1";
  };

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "An HTTP handler for `urllib2` that supports HTTP 1.1 and keepalive";
    homepage = "https://github.com/wikier/keepalive";
    license = licenses.asl20;
    broken = true; # uses use_2to3, which is no longer supported for setuptools>=58
  };

}
