{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  cmrt,
  libdrm,
  libva,
  libX11,
  libGL,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "intel-hybrid-driver";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-hybrid-driver";
    rev = finalAttrs.version;
    sha256 = "sha256-uYX7RoU1XVzcC2ea3z/VBjmT47xmzK67Y4LaiFXyJZ8=";
  };

  patches = [
    # driver_init: load libva-x11.so for any ABI version
    (fetchurl {
      url = "https://github.com/01org/intel-hybrid-driver/pull/26.diff";
      sha256 = "1ql4mbi5x1d2a5c8mkjvciaq60zj8nhx912992winbhfkyvpb3gx";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cmrt
    libdrm
    libva
    libX11
    libGL
    wayland
  ];

  enableParallelBuilding = true;

  # Workaround build failure on -fno-common toolchains like upstream gcc-10.
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  configureFlags = [
    "--enable-drm"
    "--enable-x11"
    "--enable-wayland"
  ];

  postPatch = ''
    patchShebangs ./src/shaders/gpp.py
  '';

  preConfigure = ''
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  meta = {
    homepage = "https://01.org/linuxmedia";
    description = "Intel driver for the VAAPI library with partial HW acceleration";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tadfisher ];
    platforms = lib.platforms.linux;
  };
})
