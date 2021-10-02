{ lib, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "6.2.0";

  repoName = "mail";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1ab620zhwqqjq1bs1alvpcw9jmdxjij0ywczvwbg8gqvcsc80lkn";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  patches = [
    # The app stuck when loading gravatar, temporarily reverts part
    # of https://github.com/elementary/mail/pull/600 to fix this
    ./revert-fix-warning.patch
  ];

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
    maintainers = with maintainers; [ ethancedwards8 ] ++ teams.pantheon.members;
  };
}
