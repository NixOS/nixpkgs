{ stdenv, fetchurl, autoreconfHook, sqlite }:

stdenv.mkDerivation rec {
  name = "mps-${version}";
  version = "1.114.0";

  src = fetchurl {
    url    = "http://www.ravenbrook.com/project/mps/release/${version}/mps-kit-${version}.tar.gz";
    sha256 = "1gb0rdd42ib0fai2jwm2gyii8pk59i1rhblnpdzbdj8cj5g0b30h";
  };

  buildInputs = [ autoreconfHook sqlite ];

  # Fix a slightly annoying build failure in 'make install'
  patchPhase = "substituteInPlace ./Makefile.in --replace /hot/Release /hot";

  meta = {
    description = "A flexible memory management and garbage collection library";
    homepage    = "http://www.ravenbrook.com/project/mps";
    license     = stdenv.lib.licenses.sleepycat;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
