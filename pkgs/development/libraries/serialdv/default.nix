{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "serialdv";
  version ="1.1.1";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "serialdv";
    rev = "v${version}";
    sha256 = "0swalyp8cbs7if6gxbcl7wf83ml8ch3k7ww4hws89rzpjvf070fr";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "C++ Minimal interface to encode and decode audio with AMBE3000 based devices in packet mode over a serial link.";
    homepage = "https://github.com/f4exb/serialdv";
    platforms = platforms.linux;
    maintainers = with maintainers; [ alkeryn ];
  };
}

