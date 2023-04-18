{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libmcfp";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mi5nj8vR1j3V7fIMBrSyhD57emmlkCb0F08+5s7Usj0=";
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
