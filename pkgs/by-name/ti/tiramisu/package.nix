{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tiramisu";
  version = "2.0.20240610";

  src = fetchFromGitHub {
    owner = "Sweets";
    repo = "tiramisu";
    tag = finalAttrs.version;
    hash = "sha256-owYk/YFwJbqO6/dbGKPE8SnmmH4KvH+o6uWptqQtpfI=";
  };

  buildInputs = [ glib ];

  nativeBuildInputs = [
    pkg-config
    vala
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Desktop notifications, the UNIX way";
    longDescription = ''
      tiramisu is a notification daemon based on dunst that outputs notifications
      to STDOUT in order to allow the user to process notifications any way they
      prefer.
    '';
    homepage = "https://github.com/Sweets/tiramisu";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      wishfort36
      moni
    ];
    mainProgram = "tiramisu";
  };
})
