{ lib
, stdenv
, fetchFromGitHub
, cmake}:

stdenv.mkDerivation rec {
  pname = "libutp";
  version = "unstable-2018-05-15";

  src = fetchFromGitHub {
    owner = "bittorrent";
    repo = pname;
    rev = "2b364cbb0650bdab64a5de2abb4518f9f228ec44";
    sha256 = "0z94v27c4aki4giq7551g1gnycxvi2inm2rfjmzqkc34w0n9kyqa";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "uTorrent Transport Protocol library";
    homepage = "https://github.com/bittorrent/libutp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.onny ];
  };
}
