{ pkgs, lib, fetchFromGitHub, gerbilPackages, libyaml, ... }:

{
  pname = "gerbil-libyaml";
  version = "unstable-2023-09-23";
  git-version = "398a197";
  gerbil-package = "clan";
  gerbilInputs = [ ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ libyaml ];
  version-path = "";
  softwareName = "Gerbil-LibYAML";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-libyaml";
    rev = "398a19782b1526de94b70de165c027d4b6029dac";
    sha256 = "0plmwx1i23c9nzzg6zxz2xi0y92la97mak9hg6h3c6d8kxvajb5c";
  };

  meta = with lib; {
    description = "libyaml bindings for Gerbil";
    homepage    = "https://github.com/mighty-gerbils/gerbil-libyaml";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };

  # "-L${libyaml}/lib"
}
