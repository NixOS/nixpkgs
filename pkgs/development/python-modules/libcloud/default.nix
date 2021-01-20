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
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e3e4d02f9b3197f9119e737bc704fba52f34459d4bc96d8ad8f183d600747ba";
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
