{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  cmake,
  libgsf,
  glib,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "wv2";
  version = "0.4.2";
  src = fetchurl {
    url = "mirror://sourceforge/wvware/wv2-${version}.tar.bz2";
    sha256 = "1p1qxr8z5bsiq8pvlina3c8c1vjcb5d96bs3zz4jj3nb20wnsawz";
  };

  patches = [ ./fix-include.patch ];

  # Newer versions of clang default to C++17, which removes some deprecated APIs such as bind1st.
  # Setting the language version to C++14 makes them available again.
  cmakeFlags = lib.optionals stdenv.cc.isClang [ (lib.cmakeFeature "CMAKE_CXX_STANDARD" "14") ];

  # Linking gobject explicitly fixes missing symbols (such as missing `_g_object_unref`) on Darwin.
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_LDFLAGS+=" $(pkg-config gobject-2.0 --libs)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libgsf
    glib
    libxml2
  ];

  env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  meta = {
    description = "Excellent MS Word filter lib, used in most Office suites";
    mainProgram = "wv2-config";
    license = lib.licenses.lgpl2;
    homepage = "https://wvware.sourceforge.net";
  };
}
