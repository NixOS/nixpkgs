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
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b28j265kvibgxrgxx0gwfm6cmv252c8ph1j2vb0cpms8ph5if5v";
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
