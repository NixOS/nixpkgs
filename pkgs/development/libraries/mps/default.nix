{ stdenv, fetchurl, autoreconfHook, sqlite }:

stdenv.mkDerivation rec {
  name = "mps-${version}";
  version = "1.115.0";

  src = fetchurl {
    url    = "http://www.ravenbrook.com/project/mps/release/${version}/mps-kit-${version}.tar.gz";
    sha256 = "156xdl16r44nn8svnrgfaklwrgpc3y0rxzqyp0jbdp55c6rlfl6l";
  };

  buildInputs = [ autoreconfHook sqlite ];

  meta = {
    description = "A flexible memory management and garbage collection library";
    homepage    = "http://www.ravenbrook.com/project/mps";
    license     = stdenv.lib.licenses.sleepycat;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
