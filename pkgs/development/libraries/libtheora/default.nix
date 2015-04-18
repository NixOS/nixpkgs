{stdenv, fetchurl, libogg, libvorbis, tremor, autoconf, automake, libtool, pkgconfig}:

stdenv.mkDerivation ({
  name = "libtheora-1.1.1";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz;
    sha256 = "0swiaj8987n995rc7hw0asvpwhhzpjiws8kr3s6r44bqqib2k5a0";
  };

  buildInputs = [pkgconfig];

  propagatedBuildInputs = [libogg libvorbis];

  # GCC's -fforce-addr flag is not supported by clang
  # It's just an optimization, so it's safe to simply remove it
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace "-fforce-addr" ""
  '';

  crossAttrs = {
    propagatedBuildInputs = [libogg.crossDrv tremor.crossDrv];
    configureFlags = "--disable-examples";
  };

  meta = with stdenv.lib; {
    homepage = http://www.theora.org/;
    description = "Library for Theora, a free and open video compression format";
    license = licenses.bsd3;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

# It has an old config.guess that doesn't know the mips64el.
// stdenv.lib.optionalAttrs (stdenv.system == "mips64el-linux")
{
  propagatedBuildInputs = [libogg libvorbis autoconf automake libtool];
  preConfigure = "rm config.guess; sh autogen.sh";
})
