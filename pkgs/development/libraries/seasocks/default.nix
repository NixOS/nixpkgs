{ stdenv, fetchFromGitHub, cmake, python, zlib }:

stdenv.mkDerivation rec {
  pname = "seasocks";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "mattgodbolt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vzdhp61bq2bddz7kkpygdq5adxdspjw1q6a03j6qyyimapblrg8";
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
