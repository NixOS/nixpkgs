{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  libnsl,
  libtirpc,
  libxcrypt,
  pkg-config,
  rpcbind,
  systemdLibs,
}:

stdenv.mkDerivation rec {
  pname = "ypbind-mt";
  version = "2.7.2";

  src = fetchurl {
    url = "https://github.com/thkukuk/ypbind-mt/releases/download/v${version}/ypbind-mt-${version}.tar.xz";
    hash = "sha256-Bk8vGFZzxUk9+D9kALeZ86NZ3lYRi2ujfEMnER8vzYs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libnsl
    libtirpc
    libxcrypt
    rpcbind
    systemdLibs
  ];

  meta = {
    description = "Multithreaded daemon maintaining the NIS binding informations";
    homepage = "https://github.com/thkukuk/ypbind-mt";
    changelog = "https://github.com/thkukuk/ypbind-mt/blob/master/NEWS";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ypbind";
    maintainers = with lib.maintainers; [ BarrOff ];
    platforms = lib.platforms.linux;
  };
}
