{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk4,
  glib,
  granite7,
  libadwaita,
  libgee,
  wrapGAppsHook4,
  appstream,
}:

stdenv.mkDerivation rec {
  pname = "elementary-feedback";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "feedback";
    rev = version;
    sha256 = "sha256-hAObgD2Njg1We0rGEu508khoBo+hj0DQAB7N33CVDiM=";
  };

  patches = [
    # The standard location to the metadata pool where metadata
    # will be read from is likely hardcoded as /usr/share/metainfo
    # https://github.com/ximion/appstream/blob/v0.15.2/src/as-pool.c#L117
    # https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html#spec-component-location
    ./fix-metadata-path.patch

    # Add support for AppStream 1.0.
    # https://github.com/elementary/feedback/pull/102
    (fetchpatch {
      url = "https://github.com/elementary/feedback/commit/037b20328f5200a0dac25e6835c0c3f8a7c36f39.patch";
      hash = "sha256-tjUNTCsEBjy/3lzwyIwR4VED57ATiG2CWCmRh7qps+4=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    granite7
    gtk4
    libadwaita
    libgee
    glib
  ];

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
