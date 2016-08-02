{ stdenv, fetchFromGitHub, cmake, speexdsp, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "libebur128-${version}";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "libebur128";
    rev = "v${version}";
    sha256 = "19vy3ldbf931hjvn9jf9dvw1di3yx9ljxyk2yp5cnac1wqiza3jm";
  };

  buildInputs = [ cmake speexdsp pkgconfig ];

  meta = with stdenv.lib; {
    description = "Implementation of the EBU R128 loudness standard";
    homepage = https://github.com/jiixyj/libebur128;
    license = licenses.mit;
    maintainers = [ maintainers.andrewrk ];
    platforms = platforms.unix;
  };
}
