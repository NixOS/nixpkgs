{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  libx11,
  pkg-config,
  libxext,
  libdrm,
  libxfixes,
  wayland,
  wayland-scanner,
  libffi,
  libGL,
  mesa,
  minimal ? false,
  libva1-minimal,
}:

stdenv.mkDerivation rec {
  pname = "libva" + lib.optionalString minimal "-minimal";
  # nixpkgs-update: no auto update
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libva";
    rev = version;
    sha256 = "sha256-ur59cqdZqXIY2dDUSie9XsxyRomVBxIW2IVKAgWYC38=";
  };

  outputs = [
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libdrm
  ]
  ++ lib.optionals (!minimal) [
    libva1-minimal
    libx11
    libxext
    libxfixes
    wayland
    libffi
    libGL
  ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  # Add FHS paths for non-NixOS applications.
  configureFlags =
    lib.optionals stdenv.hostPlatform.isLinux [
      "--with-drivers-path=${mesa.driverLink}/lib/dri:/usr/lib/dri:/usr/lib32/dri"
    ]
    ++ lib.optionals (!minimal) [ "--enable-glx" ];

  installFlags = [ "dummy_drv_video_ladir=$(out)/lib/dri" ];

  meta = {
    homepage = "https://www.freedesktop.org/wiki/Software/vaapi/";
    license = lib.licenses.mit;
    description = "VAAPI library: Video Acceleration API";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
