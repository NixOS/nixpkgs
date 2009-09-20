args: with args;
stdenv.mkDerivation {
  name = "ccrtp-1.7.0";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-1.7.0.tar.gz;
    sha256 = "1bjn5l476nk34gipz4jl2p83m735gzanzr046zrkx423zipx4g4j";
  };

  buildInputs = [openssl pkgconfig libgcrypt commoncpp2];

  meta = { 
    description = "GNU ccRTP is an implementation of RTP, the real-time transport protocol from the IETF";
    homepage = "http://www.gnu.org/software/ccrtp/";
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
