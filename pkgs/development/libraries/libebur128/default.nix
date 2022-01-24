{ lib, stdenv, fetchFromGitHub, cmake, speexdsp, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.2.6";
  pname = "libebur128";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "libebur128";
    rev = "v${version}";
    sha256 = "sha256-UKO2k+kKH/dwt2xfaYMrH/GXjEkIrnxh1kGG/3P5d3Y=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ speexdsp ];

  meta = with lib; {
    description = "Implementation of the EBU R128 loudness standard";
    homepage = "https://github.com/jiixyj/libebur128";
    license = licenses.mit;
    maintainers = [ maintainers.andrewrk ];
    platforms = platforms.unix;
  };
}
