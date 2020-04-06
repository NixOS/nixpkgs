{ stdenv
, desktop-file-utils
, elementary-gtk-theme
, elementary-icon-theme
, fetchFromGitHub
, flatpak
, gettext
, glib
, granite
, gtk3
, libgee
, meson
, ninja
, pantheon
, pkgconfig
, python3
, vala
, libxml2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sideload";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1nnaq4vc0aag6pckxhrma5qv8al7i00rrlg95ac4iqqmivja7i92";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
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
    flatpak
    glib
    granite
    gtk3
    libgee
    libxml2
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/elementary/sideload;
    description = "Flatpak installer, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
