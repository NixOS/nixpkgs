{
  lib,
  stdenv,
  vdr,
  alsa-lib,
  fetchFromGitHub,
  libxcb-wm,
  xorg-server,
  ffmpeg,
  libva,
  libvdpau,
  libx11,
  libxcb,
  libGL,
  libGLU,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "vdr-softhddevice";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "ua0lnj";
    repo = "vdr-plugin-softhddevice";
    hash = "sha256-MltcTiQ2tnH+wPdPwgOH1qb+aTOdo4zJizZQ3bI1JIU=";
    rev = "v${version}";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    vdr
    libxcb-wm
    ffmpeg
    alsa-lib
    libva
    libvdpau
    libxcb
    libx11
    libGL
    libGLU
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "INCDIR=${vdr.dev}/include"
  ];

  postPatch = ''
    substituteInPlace softhddev.c \
      --replace "LOCALBASE \"/bin/X\"" "\"${xorg-server}/bin/X\""
  '';

  meta = {
    inherit (src.meta) homepage;
    description = "VDR SoftHDDevice Plug-in";
    maintainers = [ lib.maintainers.ck3d ];
    license = lib.licenses.gpl2;
    inherit (vdr.meta) platforms;
  };

}
