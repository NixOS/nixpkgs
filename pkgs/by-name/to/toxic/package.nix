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

stdenv.mkDerivation rec {
  pname = "toxic";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "TokTok";
    repo = "toxic";
    rev = "v${version}";
    hash = "sha256-+nOjlQED2pbYwGV6IGeKK1pymBSrDVWCWKjZ42vib7E=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  buildInputs =
    [
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

  meta = src.meta // {
    description = "Reference CLI for Tox";
    mainProgram = "toxic";
    homepage = "https://github.com/TokTok/toxic";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux;
  };
}
