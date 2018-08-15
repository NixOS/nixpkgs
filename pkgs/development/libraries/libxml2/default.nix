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
  version = "2.9.7";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "034hylzspvkm0p4bczqbf8q05a7r2disr8dz725x4bin61ymwg7n";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-14567_CVE-2018-9251.patch";
      url = https://gitlab.gnome.org/GNOME/libxml2/commit/2240fbf5912054af025fb6e01e26375100275e74.patch;
      sha256 = "1xpqsfkzhrqasza51c821mnds5l317djrz8086fmzpyf68vld03h";
    })
    (fetchpatch {
      name = "CVE-2018-14404.patch";
      url = https://gitlab.gnome.org/GNOME/libxml2/commit/a436374994c47b12d5de1b8b1d191a098fa23594.patch;
      sha256 = "19vp7p32vrninnfa7vk9ipw7n4cl1gg16xxbhjy2d0kwp1crvzqh";
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

  doCheck = (stdenv.hostPlatform == stdenv.buildPlatform) && !stdenv.isDarwin &&
    hostPlatform.libc != "musl";

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
