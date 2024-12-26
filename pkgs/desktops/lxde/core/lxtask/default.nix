{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk3,
  intltool,
  libintl,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxtask";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxtask";
    rev = version;
    hash = "sha256-KPne7eWzOOSZjHlam3e6HifNk2Sx1vWnQYkXDFZGop0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk3
    libintl
  ];

  configureFlags = [ "--enable-gtk3" ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "http://lxde.sourceforge.net/";
    description = "Lightweight and desktop independent task manager";
    mainProgram = "lxtask";
    longDescription = ''
      LXTask is a lightweight task manager derived from xfce4 task manager
      with all xfce4 dependencies removed, some bugs fixed, and some
      improvement of UI. Although being part of LXDE, the Lightweight X11
      Desktop Environment, it's totally desktop independent and only
      requires pure GTK.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
