{ stdenv, lib, fetchurl, zlib, xz, python, findXMLCatalogs, libiconv
, supportPython ? (! stdenv ? cross) }:

stdenv.mkDerivation rec {
  name = "libxml2-${version}";
  version = "2.9.4";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "0g336cr0bw6dax1q48bblphmchgihx9p1pjmxdnrd6sh3qci3fgz";
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
