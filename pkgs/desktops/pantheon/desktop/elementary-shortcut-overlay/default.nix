{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, vala, libxml2, desktop-file-utils
, gtk3, glib, granite, libgee, elementary-icon-theme, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "shortcut-overlay";
  version = "1.0.1";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1ph4rx2l5fn0zh4fjfjlgbgskmzc0lvzqgcv7v4kr5m4rij1p4y4";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    libxml2
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    glib
    granite
    gtk3
    libgee
  ];

  meta = with stdenv.lib; {
    description = "A native OS-wide shortcut overlay to be launched by Gala";
    homepage = https://github.com/elementary/shortcut-overlay;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
