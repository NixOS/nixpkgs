{ stdenv, lib, fetchurl
, zlib, xz, python2, findXMLCatalogs
, buildPlatform, hostPlatform
, pythonSupport ? buildPlatform == hostPlatform
, icuSupport ? false, icu ? null
, enableShared ? hostPlatform.libc != "msvcrt"
, enableStatic ? !enableShared,
}:

let
  python = python2;

in stdenv.mkDerivation rec {
  name = "libxml2-${version}";
  version = "2.9.8";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "0ci7is75bwqqw2p32vxvrk6ds51ik7qgx73m920rakv5jlayax0b";
  };

  outputs = [ "bin" "dev" "out" "man" "doc" ]
    ++ lib.optional pythonSupport "py"
    ++ lib.optional enableStatic "static";
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
    ++ [ "--exec_prefix=$dev" ]
    ++ lib.optional enableStatic "--enable-static"
    ++ lib.optional (!enableShared) "--disable-shared";

  enableParallelBuilding = true;

  doCheck = (stdenv.hostPlatform == stdenv.buildPlatform) && !stdenv.isDarwin &&
    hostPlatform.libc != "musl";

  preInstall = lib.optionalString pythonSupport
    ''substituteInPlace python/libxml2mod.la --replace "${python}" "$py"'';
  installFlags = lib.optionalString pythonSupport
    ''pythondir="$(py)/lib/${python.libPrefix}/site-packages"'';

  postFixup = ''
    moveToOutput bin/xml2-config "$dev"
    moveToOutput lib/xml2Conf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '' + lib.optionalString enableStatic ''
    moveToOutput lib/libxml2.a "$static"
  '';

  passthru = { inherit version; pythonSupport = pythonSupport; };

  meta = {
    homepage = http://xmlsoft.org/;
    description = "An XML parsing library for C";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.eelco ];
  };
}
