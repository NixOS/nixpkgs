{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libcredis-0.2.3";

  src = fetchurl {
    url = "https://credis.googlecode.com/files/credis-0.2.3.tar.gz";
    sha256 = "1l3hlw9rrc11qggbg9a2303p3bhxxx2vqkmlk8avsrbqw15r1ayr";
  };

  # credis build system has no install actions, provide our own.
  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"
    mkdir -p "$out/include"

    cp -v credis-test "$out/bin/"
    cp -v *.a *.so "$out/lib/"
    cp -v *.h "$out/include/"
  '';

  meta = with stdenv.lib; {
    description = "C client library for Redis (key-value database)";
    homepage = https://code.google.com/p/credis/;
    license = licenses.bsd3; # from homepage
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
