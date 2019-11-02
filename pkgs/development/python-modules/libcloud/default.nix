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
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1spjkw5nxhbawblj5db8izff05kjw425iyydipajb7qh73vm25r0";
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
