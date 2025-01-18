{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  pkg-config,
  xorg,
  dbus,
}:

stdenv.mkDerivation rec {
  pname = "xssproxy";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "vincentbernat";
    repo = "xssproxy";
    rev = "v${version}";
    sha256 = "sha256-OPzFI1ifbV/DJo0hC2xybHKaWTprictN0muKtuq1JaY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    xorg.libX11
    xorg.libXScrnSaver
    dbus
  ];

  makeFlags = [
    "bindir=$(out)/bin"
    "man1dir=$(out)/share/man/man1"
  ];

  meta = with lib; {
    description = "Forward freedesktop.org Idle Inhibition Service calls to Xss";
    mainProgram = "xssproxy";
    homepage = "https://github.com/vincentbernat/xssproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
