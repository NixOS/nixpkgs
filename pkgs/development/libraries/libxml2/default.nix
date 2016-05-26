{ stdenv, lib, fetchurl, zlib, xz, python, findXMLCatalogs, libiconv, fetchpatch
, supportPython ? (! stdenv ? cross) }:

stdenv.mkDerivation rec {
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

  outputs = [ "dev" "out" "bin" "doc" ]
    ++ lib.optional supportPython "py";
  propagatedBuildOutputs = "out bin" + lib.optionalString supportPython " py";

  buildInputs = lib.optional supportPython python
    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ lib.optional stdenv.isFreeBSD xz;

  propagatedBuildInputs = [ zlib findXMLCatalogs ];

  configureFlags = lib.optional supportPython "--with-python=${python}"
    ++ [ "--exec_prefix=$dev" ];

  enableParallelBuilding = true;

  crossAttrs = lib.optionalAttrs (stdenv.cross.libc == "msvcrt") {
    # creating the DLL is broken ATM
    dontDisableStatic = true;
    configureFlags = configureFlags ++ [ "--disable-shared" ];

    # libiconv is a header dependency - propagating is enough
    propagatedBuildInputs =  [ findXMLCatalogs libiconv ];
  };

  preInstall = lib.optionalString supportPython
    ''substituteInPlace python/libxml2mod.la --replace "${python}" "$py"'';
  installFlags = lib.optionalString supportPython
    ''pythondir="$(py)/lib/${python.libPrefix}/site-packages"'';

  postFixup = ''
    moveToOutput bin/xml2-config "$dev"
    moveToOutput lib/xml2Conf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '';

  passthru = { inherit version; pythonSupport = supportPython; };

  meta = {
    homepage = http://xmlsoft.org/;
    description = "An XML parsing library for C";
    license = "bsd";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eelco ];
  };
}
