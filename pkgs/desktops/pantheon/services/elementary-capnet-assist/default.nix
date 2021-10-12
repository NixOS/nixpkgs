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
  version = "2.3.0";

  repoName = "capnet-assist";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1gma8a04ndivx1fd3ha9f45r642qq2li80wrd6dsrp4v3vqix9bn";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
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

  # Not useful here or in elementary - See: https://github.com/elementary/capnet-assist/issues/3
  patches = [
    ./remove-capnet-test.patch
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "A small WebKit app that assists a user with login when a captive portal is detected";
    homepage = "https://github.com/elementary/capnet-assist";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
