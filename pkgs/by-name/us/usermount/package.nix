{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  dbus,
  libnotify,
  udisks,
  gdk-pixbuf,
}:

stdenv.mkDerivation {
  pname = "usermount";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "tom5760";
    repo = "usermount";
    rev = "0d6aba3c1f8fec80de502f5b92fd8b28041cc8e4";
    sha256 = "sha256-giMHUVYdAygiemYru20VxpQixr5aGgHhevNkHvkG9z4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    libnotify
    udisks
    gdk-pixbuf
  ];

  env.NIX_CFLAGS_COMPILE = "-DENABLE_NOTIFICATIONS";

  installPhase = ''
    mkdir -p $out/bin
    mv usermount $out/bin/
  '';

  meta = {
    homepage = "https://github.com/tom5760/usermount";
    description = "Simple tool to automatically mount removable drives using UDisks2 and D-Bus";
    mainProgram = "usermount";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
