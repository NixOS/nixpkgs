{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "mps";
  version = "1.118.0";

  src = fetchFromGitHub {
    owner = "Ravenbrook";
    repo = "mps";
    rev = "refs/tags/release-${version}";
    hash = "sha256-3ql3jWLccgnQHKf23B1en+nJ9rxqmHcWd7aBr93YER0=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ sqlite ];

  # needed for 1.116.0 to build with gcc7
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-implicit-fallthrough"
    "-Wno-error=clobbered"
    "-Wno-error=cast-function-type"
  ];


  meta = {
    description = "A flexible memory management and garbage collection library";
    homepage    = "https://www.ravenbrook.com/project/mps";
    license     = lib.licenses.sleepycat;
    platforms   = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
