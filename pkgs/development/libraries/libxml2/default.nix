{ stdenv, fetchurl, zlib, xz, python ? null, pythonSupport ? true }:

assert pythonSupport -> python != null;

stdenv.mkDerivation rec {
  name = "libxml2-2.9.0";

  src = fetchurl {
    url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
    sha256 = "10ib8bpar2pl68aqksfinvfmqknwnk7i35ibq6yjl8dpb0cxj9dd";
  };

  patches = [ ./pthread-once-init.patch ];

  configureFlags = stdenv.lib.optionalString pythonSupport "--with-python=${python}";

  buildInputs = (stdenv.lib.optional pythonSupport [ python ])

    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ (stdenv.lib.optional stdenv.isFreeBSD xz);

  propagatedBuildInputs = [ zlib ];

  setupHook = ./setup-hook.sh;

  passthru = { inherit pythonSupport; };

  enableParallelBuilding = true;

  meta = {
    homepage = http://xmlsoft.org/;
    description = "An XML parsing library for C";
    license = "bsd";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
