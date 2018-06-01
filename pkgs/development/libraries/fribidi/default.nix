{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fribidi-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "fribidi";
    repo = "fribidi";
    rev = "v${version}";
    sha256 = "02483nscxc695j9b92clcdf0xb7xkfjry09kqdkkhkzl3vdcj039";
  };

  # FIXME: Please build with Meson after https://github.com/fribidi/fribidi/issues/79 solved
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
