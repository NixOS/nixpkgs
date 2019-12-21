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
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29ee7d13b9b12d1335e752a489c01eed0c270940147f418cfff89ab66faf1305";
  };

  checkInputs = [ mock pytest pytestrunner requests-mock ];
  propagatedBuildInputs = [ pycrypto requests ] ++ lib.optionals isPy27 [ typing ];

  preConfigure = "cp libcloud/test/secrets.py-dist libcloud/test/secrets.py";

  # requires a certificates file
  doCheck = false;

  meta = with lib; {
    description = "A unified interface to many cloud providers";
    homepage = http://incubator.apache.org/libcloud/;
    license = licenses.asl20;
  };

}
