{ stdenv, fetchurl, autoreconfHook, sqlite }:

stdenv.mkDerivation rec {
  name = "mps-${version}";
  version = "1.116.0";

  src = fetchurl {
    url    = "http://www.ravenbrook.com/project/mps/release/${version}/mps-kit-${version}.tar.gz";
    sha256 = "1k7vnanpgawnj84x2xs6md57pfib9p7c3acngqzkl3c2aqw8qay0";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ sqlite ];

  meta = {
    description = "A flexible memory management and garbage collection library";
    homepage    = "http://www.ravenbrook.com/project/mps";
    license     = stdenv.lib.licenses.sleepycat;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
