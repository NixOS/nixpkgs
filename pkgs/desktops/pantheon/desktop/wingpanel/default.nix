{ stdenv, fetchFromGitHub, pantheon, fetchpatch, wrapGAppsHook, pkgconfig, meson, ninja
, vala, gala, gtk3, libgee, granite, gettext, glib-networking, mutter, json-glib
, python3, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "wingpanel";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "17xl4l0znr91aj6kb9p0rswyii4gy8k16r9fvj7d96dd5szdp4mc";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gettext
    glib-networking
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gala
    granite
    gtk3
    json-glib
    libgee
    mutter
  ];

  patches = [
    ./indicators.patch
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "The extensible top panel for Pantheon";
    longDescription = ''
      Wingpanel is an empty container that accepts indicators as extensions,
      including the applications menu.
    '';
    homepage = https://github.com/elementary/wingpanel;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
