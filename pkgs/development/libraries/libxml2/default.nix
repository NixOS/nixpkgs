{ stdenv, lib, fetchurl, fetchpatch
, zlib, xz, libintl, python, gettext, ncurses, findXMLCatalogs
, libiconv
, pythonSupport ? enableShared && stdenv.buildPlatform == stdenv.hostPlatform
, icuSupport ? false, icu ? null
, enableShared ? stdenv.hostPlatform.libc != "msvcrt" && !stdenv.hostPlatform.isStatic
, enableStatic ? !enableShared
}:

stdenv.mkDerivation rec {
  pname = "libxml2";
  version = "2.9.12";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${pname}-${version}.tar.gz";
    sha256 = "14hxwzmf5xqppx77z7i0ni9lpzg1a84dqpf8j8l1fvy570g6imn8";
  };
  patches = [
    # Upstream bugs:
    #   https://bugzilla.gnome.org/show_bug.cgi?id=789714
    #   https://gitlab.gnome.org/GNOME/libxml2/issues/64
    # Patch from https://bugzilla.opensuse.org/show_bug.cgi?id=1065270 ,
    # but only the UTF-8 part.
    # Can also be mitigated by fixing malformed XML inputs, such as in
    # https://gitlab.gnome.org/GNOME/gnumeric/merge_requests/3 .
    # Other discussion:
    #   https://github.com/itstool/itstool/issues/22
    #   https://github.com/NixOS/nixpkgs/pull/63174
    #   https://github.com/NixOS/nixpkgs/pull/72342
    ./utf8-xmlErrorFuncHandler.patch

    # Work around lxml API misuse.
    # https://gitlab.gnome.org/GNOME/libxml2/issues/255
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libxml2/commit/85b1792e37b131e7a51af98a37f92472e8de5f3f.patch";
      sha256 = "epqlNs2S0Zczox3KyCB6R2aJKh87lXydlZ0x6tLHweE=";
    })
  ];

  outputs = [ "bin" "dev" "out" "man" "doc" ]
    ++ lib.optional pythonSupport "py"
    ++ lib.optional (enableStatic && enableShared) "static";

  strictDeps = true;

  buildInputs = lib.optional pythonSupport python
    ++ lib.optional (pythonSupport && python?isPy2 && python.isPy2) gettext
    ++ lib.optional (pythonSupport && python?isPy3 && python.isPy3) ncurses
    ++ lib.optional (stdenv.isDarwin &&
                     pythonSupport && python?isPy2 && python.isPy2) libintl
    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ lib.optional stdenv.isFreeBSD xz;

  propagatedBuildInputs = [ zlib findXMLCatalogs ]
    ++ lib.optional stdenv.isDarwin libiconv
    ++ lib.optional icuSupport icu;

  configureFlags = [
    "--exec_prefix=$dev"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
    (lib.withFeature icuSupport "icu")
    (lib.withFeatureAs pythonSupport "python" python)
  ];

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  enableParallelBuilding = true;

  # disable test that's problematic with newer pythons: see
  # https://mail.gnome.org/archives/xml/2017-August/msg00014.html
  preCheck = lib.optionalString (pythonSupport && !(python?pythonOlder && python.pythonOlder "3.5")) ''
    echo "" > python/tests/tstLastError.py
  '';

  doCheck = (stdenv.hostPlatform == stdenv.buildPlatform) && !stdenv.isDarwin &&
    stdenv.hostPlatform.libc != "musl";

  preInstall = lib.optionalString pythonSupport
    ''substituteInPlace python/libxml2mod.la --replace "${python}" "$py"'';
  installFlags = lib.optional pythonSupport
    "pythondir=\"${placeholder "py"}/lib/${python.libPrefix}/site-packages\"";

  postFixup = ''
    moveToOutput bin/xml2-config "$dev"
    moveToOutput lib/xml2Conf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '' + lib.optionalString (enableStatic && enableShared) ''
    moveToOutput lib/libxml2.a "$static"
  '';

  passthru = { inherit version; pythonSupport = pythonSupport; };

  meta = {
    homepage = "http://xmlsoft.org/";
    description = "An XML parsing library for C";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.eelco ];
  };
}
