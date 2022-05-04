{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "libnet";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "sam-github";
    repo = "libnet";
    rev = "v${version}";
    sha256 = "sha256-Y/wd9c4whUbfpvWvKzJV6vJN3AlA14XBejchRG6wBc4=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    homepage = "https://github.com/sam-github/libnet";
    description = "Portable framework for low-level network packet construction";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
