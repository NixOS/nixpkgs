{ lib, stdenv, fetchurl, autoreconfHook, sqlite }:

stdenv.mkDerivation rec {
  pname = "mps";
  version = "1.117.0";

  src = fetchurl {
    url    = "https://www.ravenbrook.com/project/mps/release/${version}/mps-kit-${version}.tar.gz";
    sha256 = "04ix4l7lk6nxxk9sawpnxbybvqb82lks5606ym10bc1qbc2kqdcz";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ sqlite ];

  # needed for 1.116.0 to build with gcc7
  NIX_CFLAGS_COMPILE = toString [
    "-Wno-implicit-fallthrough"
    "-Wno-error=clobbered"
    "-Wno-error=cast-function-type"
  ];


  meta = {
    broken      = true;
    description = "A flexible memory management and garbage collection library";
    homepage    = "https://www.ravenbrook.com/project/mps";
    license     = lib.licenses.sleepycat;
    platforms   = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
