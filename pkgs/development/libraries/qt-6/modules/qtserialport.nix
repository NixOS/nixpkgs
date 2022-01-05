{ qtModule
, stdenv
, lib
, qtbase
, systemd
, pkg-config

, libglvnd, libxkbcommon, vulkan-headers, libX11, libXcomposite
}:

qtModule {
  pname = "qtserialport";
  qtInputs = [ qtbase ];
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isLinux "-DNIXPKGS_LIBUDEV=\"${lib.getLib systemd}/lib/libudev\"";

  nativeBuildInputs = [ pkg-config ]; # find systemd = udev

  buildInputs = [
    systemd
    # FIXME should be propagated by qtbase
    libglvnd libxkbcommon vulkan-headers libX11 libXcomposite
  ];
}
