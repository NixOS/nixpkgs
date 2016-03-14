{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "bats-${version}";
  version = "0.4.0";

  src = fetchzip {
    url = "https://github.com/sstephenson/bats/archive/v${version}.tar.gz";
    sha256 = "05xpvfm0xky1532i3hd2l3wznxzh99bv2hxgykwdpxh18h6jr6jm";
  };

  patchPhase = "patchShebangs ./install.sh";

  installPhase = "./install.sh $out";

  meta = with stdenv.lib; {
    homepage = https://github.com/sstephenson/bats;
    description = "Bash Automated Testing System";
    maintainers = [ maintainers.lnl7 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
