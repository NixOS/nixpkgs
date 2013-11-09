{ stdenv, fetchurl, zlib, xz, python ? null, pythonSupport ? true }:

assert pythonSupport -> python != null;

stdenv.mkDerivation rec {
  name = "libxml2-2.9.1";

  src = fetchurl {
    url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
    sha256 = "1nqgd1qqmg0cg09mch78m2ac9klj9n87blilx4kymi7jcv5n8g7x";
  };

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
