{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkgconfig
, meson
, ninja
, vala
, libxml2
, desktop-file-utils
, gtk3
, glib
, granite
, libgee
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-shortcut-overlay";
  version = "1.1.2";

  repoName = "shortcut-overlay";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-TFS29vwDkTtoFcIVAbKskyLemqW9fxE7fQkM61DpDm0=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
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
    homepage = "https://github.com/elementary/shortcut-overlay";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
