{
  lib,
  stdenv,
  fetchFromGitHub,
  libdvdread,
  libdvdcss,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "vobcopy";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "barak";
    repo = "vobcopy";
    tag = version;
    hash = "sha256-lxaf+cx6sowlbA2/waW4nt/S449/mtGJ2Od9QXWxPQM=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];
  buildInputs = [
    libdvdread
    libdvdcss
  ];

  meta = {
    description = "Copies DVD .vob files to harddisk, decrypting them on the way";
    homepage = "https://github.com/barak/vobcopy";
    license = lib.licenses.gpl2Plus;

    maintainers = [ lib.maintainers.bluescreen303 ];
    platforms = lib.platforms.all;
    mainProgram = "vobcopy";
  };
}
