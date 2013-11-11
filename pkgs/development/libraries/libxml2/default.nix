{ stdenv, fetchurl, zlib, xz, python ? null, pythonSupport ? true }:

assert pythonSupport -> python != null;

#TODO: share most stuff between python and non-python builds, perhaps via multiple-output

stdenv.mkDerivation (rec {
  name = "libxml2-2.9.1";

  src = fetchurl {
    url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
    sha256 = "1nqgd1qqmg0cg09mch78m2ac9klj9n87blilx4kymi7jcv5n8g7x";
  };

  buildInputs = stdenv.lib.optional pythonSupport python
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

} // stdenv.lib.optionalAttrs pythonSupport {
  configureFlags = "--with-python=${python}";

  # this is a pair of ugly hacks to make python stuff install into the right place
  preInstall = ''substituteInPlace python/libxml2mod.la --replace "${python}" "$out"'';
  installFlags = ''pythondir="$(out)/lib/${python.libPrefix}/site-packages"'';

} // stdenv.lib.optionalAttrs (!pythonSupport && stdenv.isFreeBSD) {
  configureFlags = "--with-python=no"; # otherwise build impurity bites us
})

