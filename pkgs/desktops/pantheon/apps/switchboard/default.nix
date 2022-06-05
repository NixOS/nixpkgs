{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, python3
, ninja
, vala
, gtk3
, libgee
, libhandy
, granite
, gettext
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "switchboard";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-QMh9m6Xc0BeprZHrOgcmSireWb8Ja7Td0COYMgYw+5M=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    libhandy
  ];

  patches = [
    ./plugs-path-env.patch
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
    description = "Extensible System Settings app for Pantheon";
    homepage = "https://github.com/elementary/switchboard";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.switchboard";
  };
}
