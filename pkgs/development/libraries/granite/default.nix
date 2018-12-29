{ stdenv, fetchFromGitHub, fetchpatch, python3, meson, ninja, vala_0_40, pkgconfig, gobject-introspection, gnome3, gtk3, glib, gettext, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1zp0pp5v3j8k6ail724p7h5jj2zmznj0a2ybwfw5sspfdw5bfydh";
  };

  patches = [
    # Add Meson support that hit after 5.2.2
    (fetchpatch {
      url = "https://github.com/elementary/granite/commit/2066b377226cf327cb2d5399b6b40a2d36d47b11.patch";
      sha256 = "1bxjgq8wvl1sb79cwhmh9kwawnkkfn7c5q67cyz1fjxmamwyyi85";
    })
    (fetchpatch {
      url = "https://github.com/elementary/granite/commit/f1b29f52e3aaf0f5d6bba44c42617da265f679c8.patch";
      sha256 = "0cdp9ny6fj1lpcirab641p1qn1rbsvnsaa03hnr6zsdpim96jlvs";
    })
    # Resolve the circular dependency between granite and the datetime wingpanel indicator
    # See: https://github.com/elementary/granite/pull/242
    ./02-datetime-clock-format-gsettings.patch
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala_0_40 # should be `elementary.vala` when elementary attribute set is merged
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    hicolor-icon-theme
    gnome3.libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "An extension to GTK+ used by elementary OS";
    longDescription = ''
      Granite is a companion library for GTK+ and GLib. Among other things, it provides complex widgets and convenience functions
      designed for use in apps built for elementary OS.
    '';
    homepage = https://github.com/elementary/granite;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vozz worldofpeace ];
  };
}
