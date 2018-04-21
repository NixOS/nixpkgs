{ stdenv, fetchFromGitHub, cmake, speexdsp, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.2.4";
  name = "libebur128-${version}";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "libebur128";
    rev = "v${version}";
    sha256 = "0n81rnm8dm1zmibkr2v3q79rsd609y0dbbsrbay18njcjva88p0g";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake speexdsp ];

  meta = with stdenv.lib; {
    description = "Implementation of the EBU R128 loudness standard";
    homepage = https://github.com/jiixyj/libebur128;
    license = licenses.mit;
    maintainers = [ maintainers.andrewrk ];
    platforms = platforms.unix;
  };
}
