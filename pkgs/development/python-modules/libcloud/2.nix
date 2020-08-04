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
, backports_ssl_match_hostname
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "2.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wvm8vixhcapkfv5k6xaf8c8w647kx2rdifarg6j0s34r4jzblfg";
  };

  checkInputs = [ mock pytest pytestrunner requests-mock ];
  propagatedBuildInputs = [ pycrypto requests ]
    ++ lib.optionals isPy27 [ typing backports_ssl_match_hostname ];

  preConfigure = "cp libcloud/test/secrets.py-dist libcloud/test/secrets.py";

  # requires a certificates file
  doCheck = false;

  meta = with lib; {
    description = "A unified interface to many cloud providers";
    homepage = "http://incubator.apache.org/libcloud/";
    license = licenses.asl20;
  };

}
