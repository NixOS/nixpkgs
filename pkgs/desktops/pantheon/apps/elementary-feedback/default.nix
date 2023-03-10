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
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "feedback";
    rev = version;
    sha256 = "sha256-QvqyaI9szZuYuE3D6o4zjr5J6mvEzNHqTBWii+gjyMc=";
  };

  patches = [
    # The standard location to the metadata pool where metadata
    # will be read from is likely hardcoded as /usr/share/metainfo
    # https://github.com/ximion/appstream/blob/v0.15.2/src/as-pool.c#L117
    # https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html#spec-component-location
    ./fix-metadata-path.patch
  ];

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
    updateScript = nix-update-script { };
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
