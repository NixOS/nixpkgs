{stdenv, fetchurl, gnome3, glib, json_glib, libxml2, libarchive, libsoup, gobjectIntrospection, meson, ninja, pkgconfig,  valadoc}:

stdenv.mkDerivation rec {
  major = "0.2";
  minor = "10";
  version = "${major}.${minor}";

  name = "libhttpseverywhere-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libhttpseverywhere/${major}/libhttpseverywhere-${version}.tar.xz";
    sha256 = "235f5b7f96188d800470871774e31696fbde085b63f65bd71434af8e9e6ac8aa";
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
