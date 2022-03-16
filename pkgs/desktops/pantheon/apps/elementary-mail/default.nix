{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
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
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "mail";
    rev = version;
    sha256 = "sha256-ooqVNMgeAqGlFcfachPPfhSiKTEEcNGv5oWdM7VLWOc=";
  };

  patches = [
    # Fix build with vala 0.56
    # https://github.com/elementary/mail/pull/765
    (fetchpatch {
      url = "https://github.com/elementary/mail/commit/c3aa61d226f49147d7685cc00013469ff4df369a.patch";
      sha256 = "sha256-OxNBGIC1hrEaFSufQ59Wb0AMfdzqPt6diL4g3hbL/Ig=";
    })
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

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Mail app designed for elementary OS";
    homepage = "https://github.com/elementary/mail";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ethancedwards8 ] ++ teams.pantheon.members;
    mainProgram = "io.elementary.mail";
  };
}
