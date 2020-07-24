{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, guile, texinfo }:

let
  version = "1.0.0";
  name = "guile-fibers-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "wingo";
    repo = "fibers";
    rev = "v${version}";
    sha256 = "1r47m1m112kxf23xny99f0qkqsk6626iyc5jp7vzndfiyp5yskwi";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ guile texinfo ];

  autoreconfPhase = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Concurrent ML-like concurrency for Guile";
    homepage = "https://github.com/wingo/fibers";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
