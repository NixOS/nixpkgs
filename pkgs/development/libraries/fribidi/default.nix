{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fribidi-${version}";
  version = "0.19.7";

  src = fetchFromGitHub {
    owner = "fribidi";
    repo = "fribidi";
    rev = version;
    sha256 = "10q5jfch5qzrj2w4fbkr086ank66plx8hp7ra9a01irj80pbk96d";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  # Configure script checks for glib, but it is only used for tests.

  outputs = [ "out" "devdoc" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/fribidi/fribidi;
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
