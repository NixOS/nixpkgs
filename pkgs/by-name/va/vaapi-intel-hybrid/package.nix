{
  lib,
  stdenv,
  fetchpatch2,
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

stdenv.mkDerivation rec {
  pname = "intel-hybrid-driver";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-hybrid-driver";
    rev = version;
    sha256 = "sha256-uYX7RoU1XVzcC2ea3z/VBjmT47xmzK67Y4LaiFXyJZ8=";
  };

  patches = [
    # driver_init: load libva-x11.so for any ABI version
    (fetchpatch2 {
      url = "https://github.com/intel/intel-hybrid-driver/commit/b3b4d9a3a08d48bf6022723908a22255cc271ab7.diff?full_index=1";
      hash = "sha256-aUW0hMQuB7J3yVOUhpS2MvQu17uR6VKpSJbgazVmFfU=";
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

  meta = with lib; {
    homepage = "https://01.org/linuxmedia";
    description = "Intel driver for the VAAPI library with partial HW acceleration";
    license = licenses.mit;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.linux;
  };
}
