{ stdenv
, fetchFromGitHub
, pantheon
, wrapGAppsHook
, pkgconfig
, meson
, ninja
, vala
, gala
, gtk3
, libgee
, granite
, gettext
, mutter
, json-glib
, python3
, elementary-gtk-theme
, elementary-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "wingpanel";
  version = "unstable-2020-04-04";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "366f0f6ffa59f7ee2583d000dd334cb764f9a2b8";
    sha256 = "172r1k8m1saq80q6g2hxy4ajks8liaw9pl6lixasrzi2hsnrx53h";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-gtk-theme
    elementary-icon-theme
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
