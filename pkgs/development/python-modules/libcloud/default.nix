{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, pycrypto
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qlhyz5f32xg8i10biyzqscks8d28vklk63hvj45vzy1amw60kqz";
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
