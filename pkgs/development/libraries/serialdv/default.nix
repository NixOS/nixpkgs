{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "serialdv";
  version ="1.1.4";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "serialdv";
    rev = "v${version}";
    sha256 = "0d88h2wjhf79nisiv96bq522hkbknzm88wsv0q9k33mzmrwnrx93";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "C++ Minimal interface to encode and decode audio with AMBE3000 based devices in packet mode over a serial link.";
    homepage = "https://github.com/f4exb/serialdv";
    platforms = platforms.linux;
    maintainers = with maintainers; [ alkeryn ];
    license = licenses.gpl3;
  };
}

