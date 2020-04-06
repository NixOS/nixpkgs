{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, glib
}:

stdenv.mkDerivation rec {
  pname = "poly2tri-c";
  version = "0.1.0";

  outputs = [ "bin" "out" "dev" ];

  src = fetchFromGitHub {
    owner = "Paul-Browne";
    repo = "poly2tri-c";
    rev = "p2tc-${version}";
    sha256 = "158vm3wqfxs22b74kqc4prlvjny38qqm3kz5wrgasmx0qciwh0g8";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    glib
  ];

  NIX_CFLAGS_COMPILE = [
    "--std=gnu99"
    "-Wno-error"
  ];

  meta = with stdenv.lib; {
    description = "Library for generating, refining and rendering 2-Dimensional Constrained Delaunay Triangulations";
    homepage = "https://code.google.com/archive/p/poly2tri-c/";
    license = licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
