{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gd,
  ncurses,
  sqlite,
  check,
}:

stdenv.mkDerivation rec {
  pname = "vnstat";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "vergoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JwVYhmCscEdbwNGa+aKdOt8cIclpvjl4tmWFU3zhcwc=";
  };

  postPatch = ''
    substituteInPlace src/cfg.c --replace /usr/local $out
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gd
    ncurses
    sqlite
  ];

  nativeCheckInputs = [ check ];

  doCheck = true;

  meta = {
    description = "Console-based network statistics utility for Linux";
    longDescription = ''
      vnStat is a console-based network traffic monitor for Linux and BSD that
      keeps a log of network traffic for the selected interface(s). It uses the
      network interface statistics provided by the kernel as information source.
      This means that vnStat won't actually be sniffing any traffic and also
      ensures light use of system resources.
    '';
    homepage = "https://humdi.net/vnstat/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ evils ];
  };
}
