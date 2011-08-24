{stdenv, fetchurl, libogg, libvorbis, tremor}:

stdenv.mkDerivation {
  name = "libtheora-1.1.1";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz;
    sha256 = "0swiaj8987n995rc7hw0asvpwhhzpjiws8kr3s6r44bqqib2k5a0";
  };

  propagatedBuildInputs = [libogg libvorbis];

  crossAttrs = {
    propagatedBuildInputs = [libogg.hostDrv tremor.hostDrv];
    configureFlags = "--disable-examples";
  };
}
