{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "undaemonize";
  version = "0-unstable-2017-07-11";

  src = fetchFromGitHub {
    repo = "undaemonize";
    owner = "nickstenning";
    rev = "a181cfd900851543ee1f85fe8f76bc8916b446d4";
    hash = "sha256-Y+jO3Xo3QZE2Qel609SF4iO6VAa3wKcwEEhC14d8ebo=";
  };
  installPhase = ''
    install -D undaemonize $out/bin/undaemonize
  '';
  meta = {
    description = "Tiny helper utility to force programs which insist on daemonizing themselves to run in the foreground";
    homepage = "https://github.com/nickstenning/undaemonize";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.canndrew ];
    platforms = lib.platforms.linux;
    mainProgram = "undaemonize";
  };
}
