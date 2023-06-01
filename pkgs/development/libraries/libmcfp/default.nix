{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libmcfp";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Xz7M3TmUHGqiYZbFGSDxsVvg4VhgoVvr9TW03UxdFBw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Header only library that can collect configuration options from command line arguments";
    homepage = "https://github.com/mhekkel/libmcfp";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
