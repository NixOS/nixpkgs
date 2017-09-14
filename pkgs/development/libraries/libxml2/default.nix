{ stdenv, lib, fetchurl, fetchpatch
, zlib, xz, python2, findXMLCatalogs, libiconv
, buildPlatform, hostPlatform
, pythonSupport ? buildPlatform == hostPlatform
, icuSupport ? false, icu ? null
}:

let
  python = python2;

in stdenv.mkDerivation rec {
  name = "libxml2-${version}";
  version = "2.9.4";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "0g336cr0bw6dax1q48bblphmchgihx9p1pjmxdnrd6sh3qci3fgz";
  };

  patches = [
    (fetchpatch {
      # Contains fixes for CVE-2016-{4658,5131} and other bugs.
      name = "misc.patch";
      url = "https://git.gnome.org/browse/libxml2/patch/?id=e905f081&id2=v2.9.4";
      sha256 = "14rnzilspmh92bcpwbd6kqikj36gx78al42ilgpqgl1609krb5m5";
    })
  ];

  outputs = [ "bin" "dev" "out" "man" "doc" ]
    ++ lib.optional pythonSupport "py";
  propagatedBuildOutputs = "out bin" + lib.optionalString pythonSupport " py";

  buildInputs = lib.optional pythonSupport python
    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ lib.optional stdenv.isFreeBSD xz;

  propagatedBuildInputs = [ zlib findXMLCatalogs ] ++ lib.optional icuSupport icu;

  configureFlags =
       lib.optional pythonSupport "--with-python=${python}"
    ++ lib.optional icuSupport    "--with-icu"
    ++ [ "--exec_prefix=$dev" ];

  enableParallelBuilding = true;

  doCheck = !stdenv.isDarwin;

  crossAttrs = lib.optionalAttrs (hostPlatform.libc == "msvcrt") {
    # creating the DLL is broken ATM
    dontDisableStatic = true;
    configureFlags = configureFlags ++ [ "--disable-shared" ];

    # libiconv is a header dependency - propagating is enough
    propagatedBuildInputs =  [ findXMLCatalogs libiconv ];
  };

  preInstall = lib.optionalString pythonSupport
    ''substituteInPlace python/libxml2mod.la --replace "${python}" "$py"'';
  installFlags = lib.optionalString pythonSupport
    ''pythondir="$(py)/lib/${python.libPrefix}/site-packages"'';

  postFixup = ''
    moveToOutput bin/xml2-config "$dev"
    moveToOutput lib/xml2Conf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '';

  passthru = { inherit version; pythonSupport = pythonSupport; };

  meta = {
    homepage = http://xmlsoft.org/;
    description = "An XML parsing library for C";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eelco ];
  };
}
