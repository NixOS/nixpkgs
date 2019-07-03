{ stdenv, fetchFromGitHub, pkgconfig, cairo, pango,
  libX11, libXcomposite, autoconf, automake }:

stdenv.mkDerivation rec {
  version = "0.2.7-9-g177589f";
  name = "libaosd-${version}";

  src = fetchFromGitHub {
    owner  = "atheme-legacy";
    repo   = "libaosd";
    rev    = "${version}";
    sha256 = "1cn7k0n74p6jp25kxwcyblhmbdvgw3mikvj0m2jh4c6xccfrgb9a";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig ];
  buildInputs = [ cairo pango libX11 libXcomposite ];
  enableParallelBuilding = true;

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    longDescription = ''
      libaosd is an advanced on screen display library.

      It supports many modern features like anti-aliased text and
      composited rendering via XComposite, as well as support for
      rendering Cairo and Pango layouts.
    '';
    homepage = https://github.com/atheme-legacy/libaosd;
    license = licenses.mit;
    maintainers = with maintainers; [ unode ];
    platforms = with platforms; unix;
  };
}
