{ stdenv, lib, fetchurl, fetchpatch
, zlib, xz, python2, ncurses, findXMLCatalogs
, pythonSupport ? stdenv.buildPlatform == stdenv.hostPlatform
, icuSupport ? false, icu ? null
, enableShared ? stdenv.hostPlatform.libc != "msvcrt"
, enableStatic ? !enableShared,
}:

let
  python = python2;

in stdenv.mkDerivation rec {
  pname = "libxml2";
  version = "2.9.9";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${pname}-${version}.tar.gz";
    sha256 = "0wd881jzvqayx0ihzba29jl80k06xj9ywp16kxacdqs3064p1ywl";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-19956"; # Upstream patch
      url = "https://gitlab.gnome.org/GNOME/libxml2/commit/5a02583c7e683896d84878bd90641d8d9b0d0549.patch";
      sha256 = "05r36wb3jfiqqr595v8y1djb535pk99lvajvsi5rq7x90k8s6g61";
    })
    (fetchpatch {
      name = "CVE-2020-7595.patch";
      url = "https://gitlab.gnome.org/GNOME/libxml2/commit/0e1a49c8907645d2e155f0d89d4d9895ac5112b5.patch";
      sha256 = "0klvaxkzakkpyq0m44l9xrpn5kwaii194sqsivfm6zhnb9hhl15l";
    })
    (fetchpatch {
      name = "CVE-2019-20388.patch";
      url = "https://gitlab.gnome.org/GNOME/libxml2/commit/6088a74bcf7d0c42e24cff4594d804e1d3c9fbca.patch";
      sha256 = "070s7al2r2k92320h9cdfc2097jy4kk04d0disc98ddc165r80jl";
    })
  ];

  outputs = [ "bin" "dev" "out" "man" "doc" ]
    ++ lib.optional pythonSupport "py"
    ++ lib.optional (enableStatic && enableShared) "static";
  propagatedBuildOutputs = "out bin" + lib.optionalString pythonSupport " py";

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

  doCheck = (stdenv.hostPlatform == stdenv.buildPlatform) && !stdenv.isDarwin &&
    stdenv.hostPlatform.libc != "musl";

  preInstall = lib.optionalString pythonSupport
    ''substituteInPlace python/libxml2mod.la --replace "${python}" "$py"'';
  installFlags = lib.optionalString pythonSupport
    ''pythondir="$(py)/lib/${python.libPrefix}/site-packages"'';

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
