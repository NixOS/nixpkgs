{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, python3
, meson
, ninja
, pkg-config
, vala
, glib
, gtk4
, libgee
, libadwaita
, libportal-gtk4
, json-glib
, blueprint-compiler
, gtksourceview5
, gobject-introspection
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ pyyaml ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "textpieces";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "liferooter";
    repo = "textpieces";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3ZUHzt3oXYgsnJVDf83JUDhcF+0DLgFfOMtpKI/FTcE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    pythonEnv
    vala
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libportal-gtk4
    libgee
    json-glib
    gtksourceview5
  ];

  runtimeDependencies = [
    pythonEnv
  ];

  patches = [
  (fetchpatch {
    url = "https://github.com/liferooter/textpieces/commit/26348782b9fddc5f2ffb9497cf18ec8ce9592960.patch";
    hash = "sha256-w86PCeDhoyMPm63GCBa2Ax8KfCdlxtmGeUrmt1ZSz1k=";
  })
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
    patchShebangs scripts/
  '';

  meta = with lib; {
    description = "Quick text processing";
    longDescription = "A small tool for quick text transformations such as checksums, encoding, decoding and so on.";
    homepage = "https://github.com/liferooter/textpieces";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
})
