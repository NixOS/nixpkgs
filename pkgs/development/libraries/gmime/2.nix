{ lib, stdenv, fetchurl, pkg-config, glib, zlib, gnupg, libgpg-error, gobject-introspection }:

stdenv.mkDerivation rec {
  version = "2.6.23";
  pname = "gmime";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.6/${pname}-${version}.tar.xz";
    sha256 = "0slzlzcr3h8jikpz5a5amqd0csqh2m40gdk910ws2hnaf5m6hjbi";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config gobject-introspection ];
  propagatedBuildInputs = [ glib zlib libgpg-error ];
  configureFlags = [
    "--enable-introspection=yes"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "ac_cv_have_iconv_detect_h=yes" ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm \
      --replace /bin/mkdir mkdir

    substituteInPlace tests/test-pkcs7.c \
      --replace /bin/mkdir mkdir
  '';

  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    cp ${if stdenv.hostPlatform.isMusl then ./musl-iconv-detect.h else ./iconv-detect.h} ./iconv-detect.h
  '';

  nativeCheckInputs = [ gnupg ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/jstedfast/gmime/";
    description = "C/C++ library for creating, editing and parsing MIME messages and structures";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
