{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, mock
, pycrypto
, requests
, pytestrunner
, pytest
, requests-mock
, typing
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b14b1f5f91ceeff5cf228613e76577d7b41e790dccd53a0f647ef816fb5495c";
  };

  checkInputs = [ mock pytest pytestrunner requests-mock ];
  propagatedBuildInputs = [ pycrypto requests ] ++ lib.optionals isPy27 [ typing ];

  preConfigure = "cp libcloud/test/secrets.py-dist libcloud/test/secrets.py";

  # requires a certificates file
  doCheck = false;

  meta = with lib; {
    description = "A unified interface to many cloud providers";
    homepage = "http://incubator.apache.org/libcloud/";
    license = licenses.asl20;
  };

}
