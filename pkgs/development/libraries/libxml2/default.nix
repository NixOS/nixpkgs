{ stdenv, lib, fetchurl, fetchpatch
, zlib, xz, python, ncurses, findXMLCatalogs
, pythonSupport ? stdenv.buildPlatform == stdenv.hostPlatform
, icuSupport ? false, icu ? null
, enableShared ? stdenv.hostPlatform.libc != "msvcrt"
, enableStatic ? !enableShared,
}:

stdenv.mkDerivation rec {
  pname = "libxml2";
  version = "2.9.10";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${pname}-${version}.tar.gz";
    sha256 = "07xynh8hcxb2yb1fs051xrgszjvj37wnxvxgsj10rzmqzy9y3zma";
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
    (fetchpatch {
      name = "CVE-2020-7595.patch";
      url = "https://gitlab.gnome.org/GNOME/libxml2/commit/0e1a49c8907645d2e155f0d89d4d9895ac5112b5.patch";
      sha256 = "0klvaxkzakkpyq0m44l9xrpn5kwaii194sqsivfm6zhnb9hhl15l";
    })
  ];

  outputs = [ "bin" "dev" "out" "man" "doc" ]
    ++ lib.optional pythonSupport "py"
    ++ lib.optional (enableStatic && enableShared) "static";

  buildInputs = lib.optional pythonSupport python
    ++ lib.optional (pythonSupport && python?isPy3 && python.isPy3) ncurses
    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ lib.optional stdenv.isFreeBSD xz;

  propagatedBuildInputs = [ zlib findXMLCatalogs ] ++ lib.optional icuSupport icu;

  configureFlags = [
    "--exec_prefix=$dev"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
    (lib.withFeature icuSupport "icu")
    (lib.withFeatureAs pythonSupport "python" python)
  ];

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
    "pythondir=\"${placeholder ''py''}/lib/${python.libPrefix}/site-packages\"";

  postFixup = ''
    moveToOutput bin/xml2-config "$dev"
    moveToOutput lib/xml2Conf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '' + lib.optionalString (enableStatic && enableShared) ''
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
