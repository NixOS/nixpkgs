{ buildPythonPackage, fetchurl, stdenv, libmemcached, zlib }:
buildPythonPackage rec {
  name = "pylibmc-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/p/pylibmc/${name}.tar.gz";
    sha256 = "1mnd8lng9wmcihl7mxd940hy1dzzvzsb971qclrvmqf3b4c2dfpc";
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
