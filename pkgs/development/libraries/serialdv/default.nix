{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "serialdv";
  version ="1.1.2";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "serialdv";
    rev = "v${version}";
    sha256 = "0d2lnvfzf31i3f2klm46s87gby3yz3hc46cap0yqifzml0ff1qbm";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "C++ Minimal interface to encode and decode audio with AMBE3000 based devices in packet mode over a serial link.";
    homepage = "https://github.com/f4exb/serialdv";
    platforms = platforms.linux;
    maintainers = with maintainers; [ alkeryn ];
  };
}

