{ lib
, stdenv
, fetchFromGitLab
, fetchpatch2
, appstream-glib
, cargo
, desktop-file-utils
, itstool
, meson
, ninja
, pkg-config
, python3
, rustPlatform
, rustc
, wrapGAppsHook4
, glib
, gtk4
, libadwaita
, zbar
, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "warp";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "warp";
    rev = "v${version}";
    hash = "sha256-BUCkENpL1soiYrM1vPNQAZGUbRj1KxWbbgXR0575zGU=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-afRGCd30qJMqQeEOLDBRdVNJLMfa8/F9BO4Ib/OTtvI=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    zbar
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
  ]);

  meta = {
    description = "Fast and secure file transfer";
    homepage = "https://apps.gnome.org/Warp/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dotlambda
      foo-dogsquared
      aleksana
    ];
    platforms = lib.platforms.all;
    mainProgram = "warp";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
