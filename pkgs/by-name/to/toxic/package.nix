{
  lib,
  stdenv,
  fetchFromGitHub,
  libsodium,
  ncurses,
  curl,
  libtoxcore,
  openal,
  libvpx,
  freealut,
  libconfig,
  pkg-config,
  libopus,
  qrencode,
  gdk-pixbuf,
  libnotify,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toxic";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "TokTok";
    repo = "toxic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HNZKQPNwKLvtT/0EJlDaJnGI04gpJqXHKjd/85H3zH8=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    libtoxcore
    libsodium
    ncurses
    curl
    gdk-pixbuf
    libnotify
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isAarch32) [
    openal
    libopus
    libvpx
    freealut
    qrencode
  ];
  nativeBuildInputs = [
    pkg-config
    libconfig
  ];

  meta = finalAttrs.src.meta // {
    description = "Reference CLI for Tox";
    mainProgram = "toxic";
    homepage = "https://github.com/TokTok/toxic";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
