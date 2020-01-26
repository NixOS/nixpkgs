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
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0q5jhg3gpcjfzfi7g33fv8pb916cqsgk6543b82yy97c20902ap9";
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
