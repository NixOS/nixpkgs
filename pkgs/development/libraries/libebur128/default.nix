{ lib, stdenv, fetchFromGitHub, cmake, speexdsp, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.2.4";
  pname = "libebur128";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "libebur128";
    rev = "v${version}";
    sha256 = "0n81rnm8dm1zmibkr2v3q79rsd609y0dbbsrbay18njcjva88p0g";
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
