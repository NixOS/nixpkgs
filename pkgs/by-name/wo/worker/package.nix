{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  avfs,
  dbus,
  file, # for libmagic
  imlib2,
  libice,
  libsm,
  libx11,
  libxft,
  libxinerama,
  lua,
  openssl,
  udisks2,
  luaSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "worker";
  version = "5.4.0";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/worker-${finalAttrs.version}.tar.gz";
    hash = "sha256-tH/EFfj2bx0LwiyN7FQIjH8xR270A1opV7Zror0Zk7I=";
  };

  nativeBuildInputs = [
    avfs
    pkg-config
  ];

  buildInputs = [
    avfs
    dbus
    file
    imlib2
    libice
    libsm
    libx11
    libxft
    libxinerama
    openssl
    udisks2
  ]
  ++ lib.optionals luaSupport [
    lua
  ];

  outputs = [
    "out"
    "man"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    homepage = "http://www.boomerangsworld.de/cms/worker/index.html";
    description = "Advanced orthodox file manager";
    longDescription = ''
      Worker is a two-pane file manager for the X Window System on UN*X. The
      directories and files are shown in two independent panels supporting a lot
      of advanced file manipulation features. The main focus is to make managing
      files easy with full keyboard control, also assisting in finding files and
      directories by using history of accessed directories, live filtering, and
      access to commands by using the keyboard.
    '';
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "worker";
    maintainers = [ ];
    inherit (libx11.meta) platforms;
  };
})
