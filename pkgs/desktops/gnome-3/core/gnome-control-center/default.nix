{ fetchurl, stdenv, substituteAll, meson, ninja, pkgconfig, gnome3, ibus, gettext, upower, wrapGAppsHook
, libcanberra-gtk3, accountsservice, libpwquality, libpulseaudio
, gdk_pixbuf, librsvg, libnotify, libgudev, libsecret, gnome-color-manager
, libxml2, polkit, libxslt, libgtop, libsoup, colord, colord-gtk
, cracklib, libkrb5, networkmanagerapplet, networkmanager, glibc
, libwacom, samba, shared-mime-info, tzdata, libtool, libgnomekbd
, docbook_xsl, modemmanager, clutter, clutter-gtk, cheese, gnome-session
, fontconfig, sound-theme-freedesktop, grilo, python3
, gtk3, glib, glib-networking, gsettings-desktop-schemas
, gnome-desktop, gnome-settings-daemon, gnome-online-accounts
, vino, gnome-bluetooth, tracker, adwaita-icon-theme }:

let
  pname = "gnome-control-center";
  version = "3.30.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0gih1cmqbv803kp30704sllghb0impa0mmv3j8pndfg4zr2mnq9r";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext wrapGAppsHook libtool libxslt docbook_xsl
    shared-mime-info python3
  ];

  buildInputs = [
    ibus gtk3 glib glib-networking upower gsettings-desktop-schemas
    libxml2 gnome-desktop gnome-settings-daemon polkit libgtop
    gnome-online-accounts libsoup colord libpulseaudio fontconfig colord-gtk
    accountsservice libkrb5 networkmanagerapplet libwacom samba libnotify
    grilo libpwquality cracklib vino libcanberra-gtk3 libgudev libsecret
    gdk_pixbuf adwaita-icon-theme librsvg clutter clutter-gtk cheese
    networkmanager modemmanager gnome-bluetooth tracker
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gcm = gnome-color-manager;
      inherit glibc libgnomekbd tzdata;
    })
  ];

  postPatch = ''
    chmod +x build-aux/meson/meson_post_install.py # patchShebangs requires executable file
    patchShebangs build-aux/meson/meson_post_install.py
  '';

  mesonFlags = [
    "-Dgnome_session_libexecdir=${gnome-session}/libexec"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${sound-theme-freedesktop}/share"
      # Thumbnailers (for setting user profile pictures)
      --prefix XDG_DATA_DIRS : "${gdk_pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
    )
    for i in $out/share/applications/*; do
      substituteInPlace $i --replace "Exec=gnome-control-center" "Exec=$out/bin/gnome-control-center"
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Utilities to configure the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
