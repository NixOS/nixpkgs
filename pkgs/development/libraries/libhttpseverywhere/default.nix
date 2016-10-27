{stdenv, fetchFromGitHub, gnome3, glib, json_glib, libxml2, libarchive, libsoup, gobjectIntrospection, meson, ninja, pkgconfig,  valadoc}:

stdenv.mkDerivation rec {
  name = "libhttpseverywhere-${version}";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "grindhold";
    repo  = "libhttpseverywhere";
    rev = "${version}";
    sha256 = "0ggg1kw5yjakqqpnmjcbcpnq5m4lhc76javh8waqv2klr5mxd2a7";
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
    homepage    = https://github.com/grindhold/libhttpseverywhere;
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
