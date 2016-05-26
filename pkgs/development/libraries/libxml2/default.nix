{ stdenv, fetchurl, zlib, xz, python ? null, pythonSupport ? true, findXMLCatalogs, fetchpatch }:

assert pythonSupport -> python != null;

#TODO: share most stuff between python and non-python builds, perhaps via multiple-output

stdenv.mkDerivation (rec {
  name = "libxml2-${version}";
  version = "2.9.4";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "0g336cr0bw6dax1q48bblphmchgihx9p1pjmxdnrd6sh3qci3fgz";
  };

  # https://bugzilla.gnome.org/show_bug.cgi?id=766834#c5
  postPatch = "patch -R < " + fetchpatch {
    name = "schemas-validity.patch";
    url = "https://git.gnome.org/browse/libxml2/patch/?id=f6599c5164";
    sha256 = "0i7a0nhxwkxx6dkm8917qn0bsfn1av6ghg2f4dxanxi4bn4b1jjn";
  };

  outputs = [ "out" "doc" ];

  buildInputs = stdenv.lib.optional pythonSupport python
    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ stdenv.lib.optional stdenv.isFreeBSD xz;

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
