{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  zlib,
  gnupg,
  gpgme,
  libidn2,
  libunistring,
  gobject-introspection,
  vala,
}:

stdenv.mkDerivation rec {
  version = "3.2.14";
  pname = "gmime";

  src = fetchurl {
    # https://github.com/jstedfast/gmime/releases
    url = "https://github.com/jstedfast/gmime/releases/download/${version}/gmime-${version}.tar.xz";
    sha256 = "sha256-pes91nX3LlRci8HNEhB+Sq0ursGQXre0ATzbH75eIxc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    vala
  ];
  buildInputs = [
    zlib
    gpgme
    libidn2
    libunistring
    vala # for share/vala/Makefile.vapigen
  ];
  propagatedBuildInputs = [ glib ];
  configureFlags =
    [
      "--enable-introspection=yes"
      "--enable-vala=yes"
    ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "ac_cv_have_iconv_detect_h=yes" ];

  postPatch =
    ''
      substituteInPlace tests/testsuite.c \
        --replace /bin/rm rm
    ''
    + lib.optionalString stdenv.isDarwin ''
      # This specific test fails on darwin for some unknown reason
      substituteInPlace tests/test-filters.c \
        --replace-fail 'test_charset_conversion (datadir, "japanese", "utf-8", "iso-2022-jp");' ""
    '';

  preConfigure =
    ''
      PKG_CONFIG_VAPIGEN_VAPIGEN="$(type -p vapigen)"
      export PKG_CONFIG_VAPIGEN_VAPIGEN
    ''
    + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      cp ${
        if stdenv.hostPlatform.isMusl then ./musl-iconv-detect.h else ./iconv-detect.h
      } ./iconv-detect.h
    '';

  nativeCheckInputs = [ gnupg ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/jstedfast/gmime/";
    description = "C/C++ library for creating, editing and parsing MIME messages and structures";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
}
