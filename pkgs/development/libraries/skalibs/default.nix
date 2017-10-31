{ stdenv, fetchgit }:

let

  version = "2.4.0.1";

in stdenv.mkDerivation rec {

  name = "skalibs-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/skalibs";
    rev = "refs/tags/v${version}";
    sha256 = "1sdzm2vd9mxlwxbmjajb6n1n13dpsavdap2nbbnyx4wnzixxx9k7";
  };

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-force-devr"       # assume /dev/random works
    "--libdir=\${prefix}/lib"
    "--includedir=\${prefix}/include"
    "--sysdepdir=\${prefix}/lib/skalibs/sysdeps"
  ]
  ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ])
  # On darwin, the target triplet from -dumpmachine includes version number, but
  # skarnet.org software uses the triplet to test binary compatibility.
  # Explicitly setting target ensures code can be compiled against a skalibs
  # binary built on a different version of darwin.
  # http://www.skarnet.org/cgi-bin/archive.cgi?1:mss:623:heiodchokfjdkonfhdph
  ++ (stdenv.lib.optional stdenv.isDarwin "--build=${stdenv.system}");

  meta = {
    homepage = http://skarnet.org/software/skalibs/;
    description = "A set of general-purpose C programming libraries";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}
