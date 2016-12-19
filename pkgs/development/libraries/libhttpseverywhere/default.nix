{stdenv, fetchurl, gnome3, glib, json_glib, libxml2, libarchive, libsoup, gobjectIntrospection, meson, ninja, pkgconfig,  valadoc}:

stdenv.mkDerivation rec {
  major = "0.2";
  minor = "3";
  version = "${major}.${minor}";

  name = "libhttpseverywhere-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libhttpseverywhere/${major}/libhttpseverywhere-${version}.tar.xz";
    sha256 = "0ndk6yyfcd7iwwkv4rkivhd08k0x8v03gnp9dk1ms4bxb1l2i8l1";
  };

  nativeBuildInputs = [ gnome3.vala valadoc  gobjectIntrospection meson ninja pkgconfig ];
  buildInputs = [ glib gnome3.libgee libxml2 json_glib libsoup libarchive ];

  configurePhase = ''
    mkdir build
    cd build
    meson.py --prefix "$out" ..
  '';

  buildPhase = ''
    ninja
    ninja devhelp
  '';

  installPhase = "ninja install";

  doCheck = true;

  checkPhase = "./httpseverywhere_test";

  meta = {
    description = "library to use HTTPSEverywhere in desktop applications";
    homepage    = https://git.gnome.org/browse/libhttpseverywhere;
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
