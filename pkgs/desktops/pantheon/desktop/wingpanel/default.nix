{ stdenv, fetchFromGitHub, pantheon, fetchpatch, wrapGAppsHook, pkgconfig, meson, ninja
, vala, gala, gtk3, libgee, granite, gettext, glib-networking, mutter, json-glib
, python3, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "wingpanel";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1knkqh9q6yp7qf27zi6ki20fq4w0ia2hklvv84ivfmfa0irz0j6r";
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
    # Fix wingpanel potentially overlapping windows: https://github.com/elementary/wingpanel/pull/198
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel/commit/fc1b8ea3d6cfc5d6e4034af177eecd4542a59833.patch";
      sha256 = "0w5z56di5lxwg9vb96f9y4r2q05znwpn814m2w12l3impf5xsdqs";
    })
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
