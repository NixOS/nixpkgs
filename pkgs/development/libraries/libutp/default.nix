{ lib
, stdenv
, fetchFromGitHub
, cmake}:

stdenv.mkDerivation rec {
  pname = "libutp";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "${pname}";
    rev = "fda9f4b3db97ccb243fcbed2ce280eb4135d705b";
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

