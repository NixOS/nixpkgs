{ lib, fetchFromGitHub, ... }:

{
  pname = "gerbil-libp2p";
  version = "unstable-2022-02-03";
  git-version = "15b3246";
  softwareName = "Gerbil-libp2p";
  gerbil-package = "vyzo";

  buildInputs = [ ]; # Note: at *runtime*, this depends on go-libp2p-daemon running

  pre-src = {
    fun = fetchFromGitHub;
    owner = "vyzo";
    repo = "gerbil-libp2p";
    rev = "15b32462e683d89ffce0ff15ad373d293ea0ee5d";
    sha256 = "059lydp7d6pjgrd4pdnqq2zffzlba62ch102f01rgzf9aps3c8lz";
  };

  meta = with lib; {
    description = "Gerbil libp2p: use libp2p from Gerbil";
    homepage = "https://github.com/vyzo/gerbil-libp2p";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
