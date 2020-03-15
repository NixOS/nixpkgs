{ stdenv, fetchFromGitHub, cmake, python, zlib }:

stdenv.mkDerivation rec {
  pname = "seasocks";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "mattgodbolt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c2gc0k9wgbgn7y7wmq2ylp0gvdbmagc1x8c4jwbsncl1gy6x4g2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib python ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mattgodbolt/seasocks;
    description = "Tiny embeddable C++ HTTP and WebSocket server";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fredeb ];
  };
}
