{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  zlib,
  gnupg,
  libgpg-error,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  version = "2.6.23";
  pname = "gmime";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.6/${pname}-${version}.tar.xz";
    hash = "sha256-cUloanHKQqE5CGm2B0gVEGsGGq6qqPLvjBLBkdmnn2o=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];
  propagatedBuildInputs = [
    glib
    zlib
    libgpg-error
  ];
  configureFlags = [
    "--enable-introspection=yes"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "ac_cv_have_iconv_detect_h=yes" ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm \
      --replace /bin/mkdir mkdir

    substituteInPlace tests/test-pkcs7.c \
      --replace /bin/mkdir mkdir
  '';

  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    cp ${
      if stdenv.hostPlatform.isMusl then ./musl-iconv-detect.h else ./iconv-detect.h
    } ./iconv-detect.h
  '';

  nativeCheckInputs = [ gnupg ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/jstedfast/gmime/";
    description = "C/C++ library for creating, editing and parsing MIME messages and structures";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
