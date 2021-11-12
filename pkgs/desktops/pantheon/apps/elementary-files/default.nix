{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, gettext
, vala
, python3
, desktop-file-utils
, libcanberra
, gtk3
, glib
, libgee
, libhandy
, granite
, libnotify
, pango
, elementary-dock
, bamf
, sqlite
, libdbusmenu-gtk3
, zeitgeist
, glib-networking
, elementary-icon-theme
, libcloudproviders
, libgit2-glib
, wrapGAppsHook
, systemd
}:

stdenv.mkDerivation rec {
  pname = "elementary-files";
  version = "6.0.4";

  repoName = "files";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-FH6EYtgKADp8jjBoCwsdRdknlKS9v3iOtPiT3CyEc/8=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib-networking
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    elementary-dock
    elementary-icon-theme
    granite
    gtk3
    libcanberra
    libcloudproviders
    libdbusmenu-gtk3
    libgee
    libgit2-glib
    libhandy
    libnotify
    pango
    sqlite
    systemd
    zeitgeist
  ];

  patches = [
    ./filechooser-portal-hardcode-gsettings-for-nixos.patch
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    substituteInPlace filechooser-portal/LegacyFileChooserDialog.vala \
      --subst-var-by ELEMENTARY_FILES_GSETTINGS_PATH ${glib.makeSchemaPath "$out" "${pname}-${version}"}
  '';

  meta = with lib; {
    description = "File browser designed for elementary OS";
    homepage = "https://github.com/elementary/files";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.files";
  };
}
