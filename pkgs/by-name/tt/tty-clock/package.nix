{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "tty-clock";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "SkyNixty";
    repo = "tty-clock";
    # Use SkyNixty's fork as its more up to date
    rev = "v2.4";
    hash = "sha256-lh5pMHQDFZhp6krdwubgXk8v+XmLZSR8Rn0EhU6WjIc";
  };

  patches = [ ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/xorg62/tty-clock";
    license = lib.licenses.bsd3;
    description = "Digital clock in ncurses";
    platforms = lib.platforms.all;
    maintainers = [
      lib.maintainers.koral
      lib.maintainers.skynixty
    ];
    mainProgram = "tty-clock";
  };
}
