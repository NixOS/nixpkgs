{ buildPythonPackage, fetchPypi, stdenv, libmemcached, zlib, cyrus_sasl }:

buildPythonPackage rec {
  version = "1.6.0";
  pname = "pylibmc";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n6nvvhl0g52gpzzwdj1my6049xljkfwyxxygnwda9smrbj7pyay";
  };

  buildInputs = [ libmemcached zlib cyrus_sasl ];
  setupPyBuildFlags = [ "--with-sasl2" ];

  # requires an external memcached server running
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Quick and small memcached client for Python";
    homepage = http://sendapatch.se/projects/pylibmc/;
    license = licenses.bsd3;
  };
}
