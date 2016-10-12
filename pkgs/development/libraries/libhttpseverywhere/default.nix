{stdenv, fetchFromGitHub, gnome3, glib, json_glib, libxml2, libarchive, libsoup, gobjectIntrospection, meson, ninja, pkgconfig,  valadoc}:

stdenv.mkDerivation rec {
  name = "libhttpseverywhere-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "grindhold";
    repo  = "libhttpseverywhere";
    rev = "${version}";
    sha256 = "1b8bcg4jp2h3nwk1g7jgswsipqzkjq2gb017v07wb7nvl6kdi0rc";
  };

  nativeBuildInputs = [ gnome3.vala valadoc  gobjectIntrospection meson ninja pkgconfig ];
  buildInputs = [ glib gnome3.libgee libxml2 json_glib libsoup libarchive ];

  patches = [ ./meson.patch ];

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

  meta = {
    description = "library to use HTTPSEverywhere in desktop applications";
    homepage    = https://github.com/grindhold/libhttpseverywhere;
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
