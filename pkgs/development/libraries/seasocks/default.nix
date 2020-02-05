{ stdenv, fetchFromGitHub, cmake, python, zlib, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "seasocks";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "mattgodbolt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c2gc0k9wgbgn7y7wmq2ylp0gvdbmagc1x8c4jwbsncl1gy6x4g2";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mattgodbolt/seasocks/commit/5753b50ce3b2232d166843450043f88a4a362422.patch";
      sha256 = "1c20xjma8jdgcr5m321srpmys6b4jvqkazfqr668km3r2ck5xncl";
    })
  ];

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
