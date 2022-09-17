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
, granite
, libgee
, libhandy
, clutter-gst
, clutter-gtk
, gst_all_1
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-videos";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "videos";
    rev = version;
    sha256 = "sha256-IUIY/WgGPVRYk9O+ZocopoBF7TlLnTtScNwO6gDCALw=";
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
    clutter-gst
    clutter-gtk
    granite
    gtk3
    libgee
    libhandy
  ] ++ (with gst_all_1; [
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

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
    description = "Video player and library app designed for elementary OS";
    homepage = "https://github.com/elementary/videos";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.videos";
  };
}
