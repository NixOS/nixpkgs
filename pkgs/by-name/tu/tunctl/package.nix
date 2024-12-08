{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "tunctl";
  version = "1.5";

  src = fetchurl {
    url = "mirror://sourceforge/tunctl/tunctl-${version}.tar.gz";
    sha256 = "aa2a6c4cc6bfacb11e0d9f62334a6638a0d435475c61230116f00b6af8b14fff";
  };

  makeFlags = [ "tunctl" ];
  installPhase = ''
    mkdir -p $out/bin
    cp tunctl $out/bin
  '';

  meta = {
    homepage = "https://tunctl.sourceforge.net/";
    description = "Utility to set up and maintain TUN/TAP network interfaces";
    mainProgram = "tunctl";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
