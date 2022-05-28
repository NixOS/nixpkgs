{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, python3
, gtk3
, glib
, granite
, libgee
, libhandy
, wrapGAppsHook
, appstream
}:

stdenv.mkDerivation rec {
  pname = "elementary-feedback";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "feedback";
    rev = version;
    sha256 = "sha256-YLYHaFQAAeSt25xHF7xDJWhw+rbH9SpzoRoXaYP42jg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    appstream
    granite
    gtk3
    libgee
    libhandy
    glib
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
    description = "GitHub Issue Reporter designed for elementary OS";
    homepage = "https://github.com/elementary/feedback";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.feedback";
  };
}
