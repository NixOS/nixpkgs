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
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e2eee3802163bd0605975ed1e284cafc23203919bfa80c0cc5d3cd2543aaf97";
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
