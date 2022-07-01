{ stdenv
, lib
, substituteAll
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gssdp
, gtk4
, libsoup
}:

stdenv.mkDerivation rec {
  pname = "gssdp-tools";
  inherit (gssdp) version src;

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
    gssdp
    gtk4
    libsoup
  ];

  preConfigure = ''
    cd tools
  '';

  meta = with lib; {
    description = "Device Sniffer tool based on GSSDP framework";
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl2Plus;
    maintainers = gssdp.meta.maintainers;
    platforms = platforms.all;
  };
}
