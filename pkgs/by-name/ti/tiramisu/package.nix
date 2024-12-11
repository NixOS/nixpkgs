{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  vala,
}:

stdenv.mkDerivation rec {
  pname = "tiramisu";
  # FIXME: once a newer release in upstream is available
  version = "2.0-unstable-2023-03-29";

  src = fetchFromGitHub {
    owner = "Sweets";
    repo = "tiramisu";
    # FIXME: use the current HEAD commit as upstream has no releases since 2021
    rev = "5dddd83abd695bfa15640047a97a08ff0a8d9f9b";
    hash = "sha256-owYk/YFwJbqO6/dbGKPE8SnmmH4KvH+o6uWptqQtpfI=";
  };

  buildInputs = [ glib ];

  nativeBuildInputs = [
    pkg-config
    vala
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Desktop notifications, the UNIX way";
    longDescription = ''
      tiramisu is a notification daemon based on dunst that outputs notifications
      to STDOUT in order to allow the user to process notifications any way they
      prefer.
    '';
    homepage = "https://github.com/Sweets/tiramisu";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      wishfort36
      moni
    ];
    mainProgram = "tiramisu";
  };
}
