{ buildPythonPackage, fetchPypi, stdenv, libmemcached, zlib, cyrus_sasl }:

buildPythonPackage rec {
  version = "1.6.1";
  pname = "pylibmc";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sg7d9j0v6g3xg3finf4l1hb72c13vcyyi6rqrc9shbx903d93ca";
  };

  buildInputs = [ libmemcached zlib cyrus_sasl ];
  setupPyBuildFlags = [ "--with-sasl2" ];

  # requires an external memcached server running
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Quick and small memcached client for Python";
    homepage = "http://sendapatch.se/projects/pylibmc/";
    license = licenses.bsd3;
  };
}
