{ lib, stdenv, fetchFromGitHub, cmake, speexdsp, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.2.5";
  pname = "libebur128";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "libebur128";
    rev = "v${version}";
    sha256 = "sha256-B6MOSbLfPvadXtXHSvxZCIpAH1Bnj6sItYRp+xH5HDA=";
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
