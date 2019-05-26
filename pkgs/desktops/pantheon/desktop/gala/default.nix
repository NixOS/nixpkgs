{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, python3, ninja, vala
, desktop-file-utils, gettext, libxml2, gtk3, granite, libgee, bamf, libcanberra
, libcanberra-gtk3, gnome-desktop, mutter, clutter, plank, gobject-introspection
, elementary-icon-theme, elementary-settings-daemon, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "unstable-2019-05-14"; # Is tracking https://github.com/elementary/gala/commits/stable/juno

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "3ae100da4bbd9dabe353f468778ef63ef2dcd5d7";
    sha256 = "08xcj4z9mq511w8hdpr60nmd6j1cj7rs7rgs4s5ivyg11kg5w17b";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      versionPolicy = "master";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    clutter
    elementary-icon-theme
    gnome-desktop
    elementary-settings-daemon
    granite
    gtk3
    libcanberra
    libcanberra-gtk3
    libgee
    mutter
    plank
  ];

  patches = [ ./plugins-dir.patch ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta =  with stdenv.lib; {
    description = "A window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = https://github.com/elementary/gala;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
