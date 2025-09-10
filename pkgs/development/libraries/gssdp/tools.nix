{
  stdenv,
  lib,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gssdp_1_6,
  gtk4,
  libsoup_3,
}:

stdenv.mkDerivation rec {
  pname = "gssdp-tools";
  inherit (gssdp_1_6) version src;

  patches = [
    # Allow building tools separately from the library.
    # This is needed to break the dependency cycle.
    (replaceVars ./standalone-tools.patch {
      inherit version;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gssdp_1_6
    gtk4
    libsoup_3
  ];

  preConfigure = ''
    cd tools
  '';

  meta = with lib; {
    description = "Device Sniffer tool based on GSSDP framework";
    mainProgram = "gssdp-device-sniffer";
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl2Plus;
    teams = gssdp_1_6.meta.teams;
    platforms = platforms.all;
  };
}
