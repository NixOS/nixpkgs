{ lib, fetchFromGitHub, ... }:

{
  pname = "gerbil-libp2p";
  version = "unstable-2021-02-08";
  git-version = "04d187d";
  softwareName = "Gerbil-libp2p";
  gerbil-package = "vyzo";

  buildInputs = []; # Note: at *runtime*, this depends on go-libp2p-daemon running

  pre-src = {
    fun = fetchFromGitHub;
    owner = "vyzo";
    repo = "gerbil-libp2p";
    rev = "04d187dcb9247b5c632c28b62c647255ae14b40e";
    sha256 = "0m85n9rjpvvszkkyrp16bxp8nkjss1nb976v2kr52xljknj122ms";
  };

  meta = with lib; {
    description = "Gerbil libp2p: use libp2p from Gerbil";
    homepage    = "https://github.com/vyzo/gerbil-libp2p";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
