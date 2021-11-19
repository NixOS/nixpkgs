{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, python3
, ninja
, vala
, desktop-file-utils
, gtk3
, granite
, libgee
, libhandy
, gcr
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-capnet-assist";
  version = "2.4.0";

  repoName = "capnet-assist";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-UdkS+w61c8z2TCJyG7YsDb0n0b2LOpFyaHzMbdCJsZI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gcr
    granite
    gtk3
    libgee
    libhandy
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
    description = "A small WebKit app that assists a user with login when a captive portal is detected";
    homepage = "https://github.com/elementary/capnet-assist";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.capnet-assist";
  };
}
