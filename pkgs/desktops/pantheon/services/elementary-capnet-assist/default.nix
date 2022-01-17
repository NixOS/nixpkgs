{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
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

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "capnet-assist";
    rev = version;
    sha256 = "sha256-UdkS+w61c8z2TCJyG7YsDb0n0b2LOpFyaHzMbdCJsZI=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://github.com/elementary/capnet-assist/pull/76
    (fetchpatch {
      url = "https://github.com/elementary/capnet-assist/commit/0e77bf8023ba1b35e3a5badb72c246cabf6552b9.patch";
      sha256 = "sha256-B/KEs/TCxR+i3uQSRtWxTi2+cu0n6QLcfKCbMCvSsvs=";
    })
  ];

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
