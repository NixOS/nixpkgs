{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, pycrypto
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e2eee3802163bd0605975ed1e284cafc23203919bfa80c0cc5d3cd2543aaf97";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ pycrypto ];

  preConfigure = "cp libcloud/test/secrets.py-dist libcloud/test/secrets.py";

  # failing tests for 26 and 27
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A unified interface to many cloud providers";
    homepage = http://incubator.apache.org/libcloud/;
    license = licenses.asl20;
  };

}
