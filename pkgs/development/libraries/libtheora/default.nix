{stdenv, fetchurl, libogg, libvorbis, tremor, autoconf, automake, libtool}:

stdenv.mkDerivation ({
  name = "libtheora-1.1.1";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz;
    sha256 = "0swiaj8987n995rc7hw0asvpwhhzpjiws8kr3s6r44bqqib2k5a0";
  };

  propagatedBuildInputs = [libogg libvorbis];

  crossAttrs = {
    propagatedBuildInputs = [libogg.crossDrv tremor.crossDrv];
    configureFlags = "--disable-examples";
  };
}

# It has an old config.guess that doesn't know the mips64el.
// stdenv.lib.optionalAttrs (stdenv.system == "mips64el-linux")
{
  propagatedBuildInputs = [libogg libvorbis autoconf automake libtool];
  preConfigure = "rm config.guess; sh autogen.sh";
})
