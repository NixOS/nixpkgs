{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, ninja
, vala
, python3
, gtk3
, glib
, granite
, libgee
, elementary-icon-theme
, elementary-gtk-theme
, gettext
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-feedback";
  version = "1.0";

  repoName = "feedback";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "0rc4ifs4hd4cj0v028bzc45v64pwx21xylwrhb20jpw61ainfi8s";
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
    elementary-icon-theme
    granite
    gtk3
    elementary-gtk-theme
    libgee
    glib
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "GitHub Issue Reporter designed for elementary OS";
    homepage = https://github.com/elementary/feedback;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
