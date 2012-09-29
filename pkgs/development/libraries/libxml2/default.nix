{ stdenv, fetchurl, zlib, python ? null, pythonSupport ? true }:

assert pythonSupport -> python != null;

stdenv.mkDerivation rec {
  name = "libxml2-2.9.0";

  src = fetchurl {
    url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
    sha256 = "10ib8bpar2pl68aqksfinvfmqknwnk7i35ibq6yjl8dpb0cxj9dd";
  };

  configureFlags = stdenv.lib.optionalString pythonSupport "--with-python=${python}";

  buildInputs = stdenv.lib.optional pythonSupport [ python ];

  propagatedBuildInputs = [ zlib ];

  setupHook = ./setup-hook.sh;

  passthru = { inherit pythonSupport; };

  meta = {
    homepage = http://xmlsoft.org/;
    description = "A XML parsing library for C";
    license = "bsd";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.platforms.eelco ];
  };
}
