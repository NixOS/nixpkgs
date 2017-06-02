{ buildPythonPackage, fetchPypi, stdenv, libmemcached, zlib }:
buildPythonPackage rec {
  version = "1.5.2";
  pname = "pylibmc";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc54e28a9f1b5b2ec0c030da29c7ad8a15c2755bd98aaa4142eaf419d5fabb33";
  };

  buildInputs = [ libmemcached zlib ];

  # requires an external memcached server running
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Quick and small memcached client for Python";
    homepage = http://sendapatch.se/projects/pylibmc/;
    license = licenses.bsd3;
  };
}
