{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, python3
, vala
, desktop-file-utils
, gtk3
, libxml2
, libhandy
, webkitgtk
, folks
, libgdata
, sqlite
, granite
, elementary-icon-theme
, evolution-data-server
, appstream
, wrapGAppsHook
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-mail";
  version = "unstable-2021-06-21";

  repoName = "mail";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "c64c87fabb31dea8dc388152d5a835401993acf4";
    sha256 = "yEUg1IbYbzOJiklnqR23X+aGVE9j4F9iH8FkmlB15x4=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    evolution-data-server
    folks
    granite
    gtk3
    libgdata
    libgee
    libhandy
    sqlite
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Mail app designed for elementary OS";
    homepage = "https://github.com/elementary/mail";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers ++ [ maintainers.ethancedwards8 ];
  };
}
