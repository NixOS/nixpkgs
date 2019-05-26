{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, python3, ninja
, vala, gtk3, libgee, granite, gettext, clutter-gtk, libunity
, elementary-icon-theme, wrapGAppsHook, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0lsrn636b0f9a58jbid6mlhgrf8ajnh7phwmhgxz55sz7k7qa58g";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    elementary-icon-theme
    granite
    gtk3
    libgee
    libunity
  ];

  patches = [ ./plugs-path-env.patch ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Extensible System Settings app for Pantheon";
    homepage = https://github.com/elementary/switchboard;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
