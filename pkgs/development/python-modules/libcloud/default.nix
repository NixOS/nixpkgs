{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, pycrypto
, requests
, pytestrunner
, pytest
, requests-mock
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcc165f2cc2db9a379c6d3a17b3beb9081bb64ba5c0bf7bbb58da864810092f0";
  };

  checkInputs = [ mock pytest pytestrunner requests-mock ];
  propagatedBuildInputs = [ pycrypto requests ];

  preConfigure = "cp libcloud/test/secrets.py-dist libcloud/test/secrets.py";

  # requires a certificates file
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A unified interface to many cloud providers";
    homepage = http://incubator.apache.org/libcloud/;
    license = licenses.asl20;
  };

}
