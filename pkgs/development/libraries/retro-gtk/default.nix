{ lib
, stdenv
, fetchurl
, cmake
, meson
, ninja
, pkg-config
, epoxy
, glib
, gtk3
, libpulseaudio
, libsamplerate
, gobject-introspection
, vala
, gtk-doc
}:

stdenv.mkDerivation rec {
  pname = "retro-gtk";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/retro-gtk/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1lnb7dwcj3lrrvdzd85dxwrlid28xf4qdbrgfjyg1wn1z6sv063i";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/retro-gtk/-/merge_requests/150
    ./gio-unix.patch
  ];

  nativeBuildInputs = [
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    epoxy
    glib
    gtk3
    libpulseaudio
    libsamplerate
  ];

  meta = with lib; {
    description = "The GTK Libretro frontend framework";
    longDescription = ''
      Libretro is a plugin format design to implement video game
      console emulators, video games and similar multimedia
      software. Such plugins are called Libretro cores.

      RetroGTK is a framework easing the use of Libretro cores in
      conjunction with GTK.

      It encourages the cores to be installed in a well defined
      centralized place — namely the libretro subdirectory of your lib
      directory — and it recommends them to come with Libretro core
      descriptors.
    '';
    homepage = "https://gitlab.gnome.org/GNOME/retro-gtk";
    changelog = "https://gitlab.gnome.org/GNOME/retro-gtk/-/blob/master/NEWS";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.DamienCassou ];
    platforms = platforms.all;
  };
}
