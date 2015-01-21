{ stdenv, fetchgit }:

let

  version = "2.2.0.0";

in stdenv.mkDerivation rec {

  name = "skalibs-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/skalibs";
    rev = "refs/tags/v${version}";
    sha256 = "1ww45ygrws7h3p3p7y3blc5kzvvy5fmzb158ngfbdamf0pgc5vkn";
  };

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-force-devr"       # assume /dev/random works
    "--libdir=\${prefix}/lib"
    "--includedir=\${prefix}/include"
    "--sysdepdir=\${prefix}/lib/skalibs/sysdeps"
  ] ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ]);

  meta = {
    homepage = http://skarnet.org/software/skalibs/;
    description = "A set of general-purpose C programming libraries";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
