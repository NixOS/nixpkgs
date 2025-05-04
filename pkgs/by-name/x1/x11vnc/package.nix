{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  zlib,
  libjpeg,
  xorg,
  coreutils,
  libvncserver,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x11vnc";
  version = "0.9.17";

  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "x11vnc";
    tag = finalAttrs.version;
    hash = "sha256-Uc5AzEmfU5kcgfJz4qnry2w6qk/Wzzb/ohho9MnSieM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    xorg.libXfixes
    xorg.xorgproto
    openssl
    xorg.libXdamage
    zlib
    xorg.libX11
    libjpeg
    xorg.libXtst
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    libvncserver
  ];

  postPatch = ''
    substituteInPlace src/unixpw.c \
        --replace-fail '"/bin/su"' '"/run/wrappers/bin/su"' \
        --replace-fail '"/bin/true"' '"${coreutils}/bin/true"'

    sed -i -e '/#!\/bin\/sh/a"PATH=${xorg.xdpyinfo}\/bin:${xorg.xauth}\/bin:$PATH\\n"' -e 's|/bin/su|/run/wrappers/bin/su|g' src/ssltools.h

    # Xdummy script is currently broken, so we avoid building it. This removes everything Xdummy-related from the affected Makefile
    sed -i '/if HAVE_X11/,/endif/d' misc/Makefile.am
  '';

  meta = with lib; {
    description = "VNC server connected to a real X11 screen";
    homepage = "https://github.com/LibVNC/x11vnc/";
    changelog = "https://github.com/LibVNC/x11vnc/releases/tag/${finalAttrs.version}";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    mainProgram = "x11vnc";
  };
})
