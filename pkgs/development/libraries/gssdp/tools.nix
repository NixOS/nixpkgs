{ stdenv
, lib
, substituteAll
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gssdp_1_6
, gtk4
, libsoup_3
}:

stdenv.mkDerivation rec {
  pname = "gssdp-tools";
  inherit (gssdp_1_6) version src;

  patches = [
    # Allow building tools separately from the library.
    # This is needed to break the depenency cycle.
    (substituteAll {
      src = ./standalone-tools.patch;
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
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl2Plus;
    maintainers = gssdp_1_6.meta.maintainers;
    platforms = platforms.all;
  };
}
