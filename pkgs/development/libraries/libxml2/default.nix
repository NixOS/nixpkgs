{ stdenv, fetchurl, zlib, xz, python ? null, pythonSupport ? true, findXMLCatalogs }:

assert pythonSupport -> python != null;

#TODO: share most stuff between python and non-python builds, perhaps via multiple-output

let
  version = "2.9.2";
in

stdenv.mkDerivation (rec {
  name = "libxml2-${version}";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "1g6mf03xcabmk5ing1lwqmasr803616gb2xhn7pll10x2l5w6y2i";
  };

  buildInputs = stdenv.lib.optional pythonSupport python
    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ (stdenv.lib.optional stdenv.isFreeBSD xz);

  propagatedBuildInputs = [ zlib findXMLCatalogs ];

  passthru = { inherit pythonSupport version; };

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

} // stdenv.lib.optionalAttrs (!pythonSupport) {
  configureFlags = "--with-python=no"; # otherwise build impurity bites us
})

